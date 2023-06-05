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
  })  : members = members ?? <String>[AuthMethods.uid],
        startingTime = startingTime ?? DateTime.now(),
        endingTime = endingTime ?? DateTime.now(),
        notes = notes ?? <Note>[];

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid,
      'title': title,
      'description': description,
      'agencies': agencies,
      'members': members,
      'starting_time': startingTime,
      'ending_time': endingTime,
      'logo': logo,
      'notes': notes.map((Note x) => x.toMap()).toList(),
    };
  }

  // ignore: sort_constructors_first
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      pid: map['pid'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      agencies: List<String>.from((map['agencies'] ?? <String>[])),
      members: List<String>.from((map['members'] ?? <String>[])),
      startingTime: TimeFun.parseTime(map['starting_time']),
      endingTime: TimeFun.parseTime(map['ending_time']),
      logo: map['logo'] ?? '',
      notes: List<Note>.from(
        (map['notes'] as List<int>).map<Note>(
          (int x) => Note.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
