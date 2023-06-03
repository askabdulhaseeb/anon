import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../database/firebase/auth_methods.dart';
import '../../enums/user/user_designation.dart';
import 'member_detail.dart';
part 'agency.g.dart';

@HiveType(typeId: 2)
class Agency extends HiveObject {
  Agency({
    required this.agencyID,
    required this.agencyCode,
    required this.name,
    String? websiteURL,
    String? logoURL,
    List<String>? members,
    List<MemberDetail>? activeMembers,
    List<MemberDetail>? pendingRequest,
    List<MemberDetail>? requestHistory,
    bool? isCurrenlySelected = true,
  })  : websiteURL = websiteURL ?? '',
        logoURL = logoURL ?? '',
        members = members ?? <String>[AuthMethods.uid],
        activeMembers = activeMembers ??
            <MemberDetail>[
              MemberDetail(
                uid: AuthMethods.uid,
                designation: UserDesignation.admin,
                isAccepted: true,
                isPending: false,
                responcedBy: AuthMethods.uid,
              ),
            ],
        pendingRequest = pendingRequest ?? <MemberDetail>[],
        requestHistory = requestHistory ??
            <MemberDetail>[
              MemberDetail(
                uid: AuthMethods.uid,
                designation: UserDesignation.admin,
                isAccepted: true,
                isPending: false,
                responcedBy: AuthMethods.uid,
              ),
            ],
        isCurrenlySelected = isCurrenlySelected ?? false;

  @HiveField(0)
  final String agencyID;
  @HiveField(1)
  final String name;
  // field 2 not available
  @HiveField(3)
  final String agencyCode;
  @HiveField(4)
  final String websiteURL;
  @HiveField(5)
  final List<String> members;
  @HiveField(6) // Class Code: 20
  final List<MemberDetail> activeMembers;
  @HiveField(7) // Class Code: 20
  final List<MemberDetail> pendingRequest;
  @HiveField(8) // Class Code: 20
  final List<MemberDetail> requestHistory;
  @HiveField(9)
  String logoURL;
  @HiveField(10, defaultValue: false)
  bool isCurrenlySelected;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'agency_id': agencyID,
      'name': name,
      'logo_url': logoURL,
      'agency_code': agencyCode,
      'website_url': websiteURL,
      'members': members,
      'active_members':
          activeMembers.map((MemberDetail x) => x.toMap()).toList(),
      'pending_request':
          pendingRequest.map((MemberDetail x) => x.toMap()).toList(),
      'request_history':
          requestHistory.map((MemberDetail x) => x.toMap()).toList(),
    };
  }

  // ignore: sort_constructors_first
  factory Agency.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    final List<dynamic> activeData =
        doc.data()?['active_members'] ?? <dynamic>[];
    final List<dynamic> pendingData =
        doc.data()?['pending_request'] ?? <dynamic>[];
    final List<dynamic> historyData =
        doc.data()?['request_history'] ?? <dynamic>[];
    List<MemberDetail> active = <MemberDetail>[];
    List<MemberDetail> pending = <MemberDetail>[];
    List<MemberDetail> history = <MemberDetail>[];

    for (dynamic element in activeData) {
      active.add(MemberDetail.fromMap(element));
    }
    for (dynamic element in pendingData) {
      pending.add(MemberDetail.fromMap(element));
    }
    for (dynamic element in historyData) {
      history.add(MemberDetail.fromMap(element));
    }

    return Agency(
      agencyID: doc.data()?['agency_id'] ?? '',
      name: doc.data()?['name'] ?? '',
      logoURL: doc.data()?['logo_url'] ?? '',
      agencyCode: doc.data()?['agency_code'] ?? '',
      websiteURL: doc.data()?['website_url'] ?? '',
      members: List<String>.from((doc.data()?['members'] ?? <String>[])),
      activeMembers: active,
      pendingRequest: pending,
      requestHistory: history,
      isCurrenlySelected: false,
    );
  }

  void requestAction({
    required String uid,
    required bool isAccepted,
    required UserDesignation designation,
  }) {
    final int index =
        pendingRequest.indexWhere((MemberDetail element) => element.uid == uid);
    assert(index >= 0);
    final MemberDetail temp = pendingRequest[index];
    temp
      ..isAccepted = isAccepted
      ..isPending = false
      ..designation = designation;
    requestHistory.add(temp);
    if (isAccepted) activeMembers.add(temp);
    pendingRequest
        .removeWhere((MemberDetail element) => element.uid == temp.uid);
  }

  Map<String, dynamic> updateRequest() {
    return <String, dynamic>{
      'active_members':
          activeMembers.map((MemberDetail x) => x.toMap()).toList(),
      'pending_request':
          pendingRequest.map((MemberDetail x) => x.toMap()).toList(),
      'request_history':
          requestHistory.map((MemberDetail x) => x.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'ID: $agencyID - state: $isCurrenlySelected';
  }
}
