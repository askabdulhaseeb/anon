import 'package:flutter/material.dart';

import '../../database/firebase/agency_api.dart';
import '../../database/local/local_user.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../models/user/app_user.dart';
import '../custom/custom_elevated_button.dart';
import '../custom/custom_profile_photo.dart';
import '../custom/show_loading.dart';

class UserPendingRequestTile extends StatefulWidget {
  const UserPendingRequestTile({
    required this.detail,
    required this.agency,
    super.key,
  });
  final MemberDetail detail;
  final Agency agency;

  @override
  State<UserPendingRequestTile> createState() => _UserPendingRequestTileState();
}

class _UserPendingRequestTileState extends State<UserPendingRequestTile> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
      future: LocalUser().user(widget.detail.uid),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.hasData) {
          final AppUser user = snapshot.data!;
          return ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Color(user.defaultColor)),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Color(user.defaultColor),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CustomProfilePhoto(user, size: 30),
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 4),
                  const SizedBox(height: 8),
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  isLoading
                      ? const ShowLoading()
                      : widget.agency.pendingRequest.any(
                              (MemberDetail element) => element.uid == user.uid)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    widget.agency.onRejectRequest(
                                        value: widget.detail.uid);
                                    await AgencyAPI()
                                        .updateRequest(widget.agency);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  child: CustomElevatedButton(
                                    isLoading: false,
                                    onTap: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      widget.agency.onAcceptRequest(
                                        uid: widget.detail.uid,
                                        designation: widget.detail.designation,
                                      );
                                      await AgencyAPI()
                                          .updateRequest(widget.agency);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    title: 'Accept',
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox()
                ],
              ),
            ),
          );
        } else {
          return const ShowLoading();
        }
      },
    );
    // return FutureBuilder<AppUser>(
    //     future: LocalUser().user(widget.detail.uid),
    //     builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
    //       if (snapshot.hasData) {
    //         final AppUser user = snapshot.data!;
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 8),
    //           child: Row(
    //             children: <Widget>[
    //               CustomProfilePhoto(user),
    //               const SizedBox(width: 10),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Text(
    //                       user.name,
    //                       style: const TextStyle(fontWeight: FontWeight.bold),
    //                     ),
    //                     Text(
    //                       TimeFun.timeInWords(widget.detail.requestTime),
    //                       style:
    //                           TextStyle(color: Theme.of(context).disabledColor),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    // isLoading
    //     ? const ShowLoading()
    //     : widget.agency.pendingRequest.any(
    //             (MemberDetail element) => element.uid == user.uid)
    //         ? Row(
    //             children: <Widget>[
    //               TextButton(
    //                 onPressed: () async {
    //                   setState(() {
    //                     isLoading = true;
    //                   });
    //                   widget.agency.onRejectRequest(
    //                       value: widget.detail.uid);
    //                   await AgencyAPI()
    //                       .updateRequest(widget.agency);
    //                   setState(() {
    //                     isLoading = false;
    //                   });
    //                 },
    //                 child: const Text(
    //                   'Reject',
    //                   style: TextStyle(color: Colors.red),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: 90,
    //                 child: CustomElevatedButton(
    //                   isLoading: false,
    //                   onTap: () async {
    //                     setState(() {
    //                       isLoading = true;
    //                     });
    //                     widget.agency.onAcceptRequest(
    //                       uid: widget.detail.uid,
    //                       designation: widget.detail.designation,
    //                     );
    //                     await AgencyAPI()
    //                         .updateRequest(widget.agency);
    //                     setState(() {
    //                       isLoading = false;
    //                     });
    //                   },
    //                   textStyle:
    //                       const TextStyle(color: Colors.white),
    //                   title: 'Accept',
    //                 ),
    //               ),
    //             ],
    //           )
    //         : const SizedBox(),
    //             ],
    //           ),
    //         );
    //       } else if (snapshot.hasError) {
    //         return const Text('Issue');
    //       } else {
    //         return const ShowLoading();
    //       }
    //     });
  }
}
