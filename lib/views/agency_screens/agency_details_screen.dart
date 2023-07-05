import 'package:flutter/material.dart';

import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_agency.dart';
import '../../enums/user/user_designation.dart';
import '../../functions/helping_funcation.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../widgets/custom/custom_list_tile_widget.dart';
import '../../widgets/custom/custom_square_photo.dart';
import '../../widgets/custom/show_loading.dart';

class AgencyDetailsScreen extends StatelessWidget {
  const AgencyDetailsScreen({Key? key}) : super(key: key);
  static const String routeName = '/agency-detail';
  @override
  Widget build(BuildContext context) {
    final String agencyID =
        ModalRoute.of(context)!.settings.arguments as String;
    // TODO: On Edit
    return Scaffold(
      appBar: AppBar(title: const Text('Details'), centerTitle: true),
      body: FutureBuilder<Agency?>(
        future: LocalAgency().agency(agencyID),
        builder: (BuildContext context, AsyncSnapshot<Agency?> snapshot) {
          if (snapshot.hasData) {
            final Agency agency = snapshot.data!;
            final String me = AuthMethods.uid;
            final bool canEdit = agency.activeMembers.any(
                (MemberDetail element) =>
                    element.uid == me &&
                    element.designation == UserDesignation.admin);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CustomSquarePhoto(
                          agency.logoURL,
                          name: agency.name,
                          defaultColor: Colors.grey.value,
                          size: 120,
                        ),
                      ),
                    ),
                    CustomListTileWidget(
                      leadingIcon: Icons.workspace_premium,
                      header: 'Name',
                      title: agency.name,
                      canEdit: canEdit,
                      onEdit: () {},
                    ),
                    CustomListTileWidget(
                      leadingIcon: Icons.code,
                      header: 'Agency Code',
                      title: agency.agencyCode,
                      canEdit: false,
                      onEdit: () {
                        HelpingFuncation().copyToClipboard(
                          context,
                          agency.agencyCode,
                        );
                      },
                      trailing: Icon(
                        Icons.copy,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .color!
                            .withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const ShowLoading();
          }
        },
      ),
    );
  }
}
