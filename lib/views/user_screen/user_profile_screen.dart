import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_user.dart';
import '../../functions/helping_funcation.dart';
import '../../models/user/app_user.dart';
import '../../widgets/custom/custom_list_tile_widget.dart';
import '../../widgets/custom/custom_network_image.dart';
import '../../widgets/custom/show_loading.dart';

class UserProfileScreeen extends StatelessWidget {
  const UserProfileScreeen({Key? key}) : super(key: key);
  static const String routeName = '/user_profile';
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String userID = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: FutureBuilder<AppUser>(
          future: LocalUser().user(userID),
          builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
            if (snapshot.hasData) {
              final AppUser user = snapshot.data!;
              final bool canEdit = AuthMethods.uid == user.uid;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomNetworkImage(
                          imageURL: user.imageURL,
                          size: size.width,
                          placeholder:
                              HelpingFuncation().photoPlaceholder(user.name),
                          placeholderBgColor: Color(user.defaultColor),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomListTileWidget(
                        header: 'Name',
                        title: user.name,
                        canEdit: canEdit,
                        onEdit: () {},
                      ),
                      CustomListTileWidget(
                        header: 'Email',
                        leadingIcon: CupertinoIcons.mail,
                        title: user.email,
                        canEdit: canEdit,
                        onEdit: () {},
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
            } else {
              return const ShowLoading();
            }
          }),
    );
  }
}
