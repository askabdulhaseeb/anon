import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/local/local_user.dart';
import '../../models/user/app_user.dart';
import '../custom/custom_profile_photo.dart';
import '../custom/show_loading.dart';

class AddableMemberWidget extends StatefulWidget {
  const AddableMemberWidget({
    required this.users,
    required this.alreadyMember,
    this.title = 'Project Member',
    Key? key,
  }) : super(key: key);
  final List<String> users;
  final List<AppUser> alreadyMember;
  final String title;
  @override
  State<AddableMemberWidget> createState() => _AddableMemberWidgetState();
}

class _AddableMemberWidgetState extends State<AddableMemberWidget> {
  final List<AppUser> newAdded = <AppUser>[];
  String search = '';
  @override
  void initState() {
    newAdded.addAll(widget.alreadyMember);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.9,
      initialChildSize: 0.8,
      minChildSize: 0.7,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) =>
          SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(newAdded),
                    child: const Text(
                      'Add Member',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              CupertinoSearchTextField(
                onChanged: (String? value) => setState(() {
                  search = value ?? '';
                }),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<AppUser>>(
                  future: LocalUser().stringListToObjectList(widget.users),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<List<AppUser>> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final List<AppUser> users = snapshot.data ?? <AppUser>[];
                      final List<AppUser> searchedUser = users
                          .where((AppUser element) => element.name
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList();
                      return ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: searchedUser.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AppUser user = searchedUser[index];
                          return _UserTile(
                            user: user,
                            isSelected: newAdded.contains(user),
                            onTap: () {
                              setState(() {
                                newAdded.any(
                                        (AppUser element) => user == element)
                                    ? newAdded.remove(user)
                                    : newAdded.add(user);
                              });
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('ERROR'));
                    } else {
                      return const ShowLoading();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    required this.isSelected,
    required this.onTap,
  });
  final AppUser user;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: <Widget>[
            CustomProfilePhoto(user.imageURL, name: user.name),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(user.email, style: const TextStyle(color: Colors.grey))
                ],
              ),
            ),
            Icon(isSelected ? Icons.circle : Icons.circle_outlined),
          ],
        ),
      ),
    );
  }
}
