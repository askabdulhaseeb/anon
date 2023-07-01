import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user/app_user.dart';
import '../../providers/new_project_provider.dart';
import '../custom/custom_profile_photo.dart';

class NewProjectAddMemberWidget extends StatelessWidget {
  const NewProjectAddMemberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewProjectProvider>(
      builder: (BuildContext context, NewProjectProvider newProjPro, _) {
        final List<AppUser> members = newProjPro.members;
        return Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: newProjPro.members.isEmpty
                    ? Center(
                        child: Text(
                          'Click on add member 👉',
                          style:
                              TextStyle(color: Theme.of(context).disabledColor),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: members.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          width: 50,
                          child: Stack(
                            alignment: Alignment.topRight,
                            // clipBehavior: Clip.none,
                            children: <Widget>[
                              CustomProfilePhoto(
                                members[index],
                                size: 50,
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: GestureDetector(
                                  onTap: () =>
                                      newProjPro.onRemoveMember(members[index]),
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            TextButton.icon(
              onPressed: () async => await newProjPro.addMember(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Members'),
            ),
          ],
        );
      },
    );
  }
}
