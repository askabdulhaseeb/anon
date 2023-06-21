import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../database/firebase/auth_methods.dart';
import '../../functions/time_functions.dart';
import 'note.dart';

part 'project.g.dart';

@HiveType(typeId: 3)
class Project extends HiveObject {
  Project({
    required this.pid,
    required this.title,
    required this.agencies,
    required this.logo,
    this.description = '',
    List<String>? members,
    DateTime? startingTime,
    DateTime? endingTime,
    List<Note>? notes,
    String? createdBy,
  })  : members = members ?? <String>[AuthMethods.uid],
        startingTime = startingTime ?? DateTime.now(),
        endingTime = endingTime ?? DateTime.now(),
        notes = notes ?? <Note>[],
        createdBy = createdBy ?? AuthMethods.uid;

  @HiveField(0)
  final String pid;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<String> agencies;
  @HiveField(3)
  final List<String> members;
  @HiveField(4)
  final DateTime startingTime;
  @HiveField(5)
  final DateTime endingTime;
  @HiveField(6, defaultValue: '')
  final String logo;
  @HiveField(7, defaultValue: <Note>[]) // Class Code: 31
  final List<Note> notes;
  @HiveField(8, defaultValue: '')
  final String description;
  @HiveField(9, defaultValue: '')
  final String createdBy;

  Map<String, dynamic> toMap() {
    final String me = AuthMethods.uid;
    if (!members.contains(me)) members.add(me);
    return <String, dynamic>{
      'pid': pid,
      'title': title,
      'description': description,
      'agencies': agencies,
      'members': members,
      'starting_time': startingTime,
      'ending_time': endingTime,
      'logo': logo,
      'created_by': createdBy,
      'notes': notes.map((Note x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toUpdateMembers() {
    final String me = AuthMethods.uid;
    if (!members.contains(me)) members.add(me);
    return <String, dynamic>{'members': members};
  }

  // ignore: sort_constructors_first
  factory Project.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Project(
      pid: doc.data()?['pid'] ?? '',
      title: doc.data()?['title'] ?? '',
      description: doc.data()?['description'] ?? '',
      agencies: List<String>.from((doc.data()?['agencies'] ?? <String>[])),
      members: List<String>.from((doc.data()?['members'] ?? <String>[])),
      startingTime: TimeFun.parseTime(doc.data()?['starting_time']),
      endingTime: TimeFun.parseTime(doc.data()?['ending_time']),
      logo: doc.data()?['logo'] ?? '',
      createdBy: doc.data()?['created_by'] ?? '',
      notes: List<Note>.from(
        (doc.data()?['notes'] as List<dynamic>).map<Note>(
          (dynamic x) => Note.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
