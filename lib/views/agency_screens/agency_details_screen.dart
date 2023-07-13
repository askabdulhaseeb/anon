import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/firebase/agency_api.dart';
import '../../database/firebase/auth_methods.dart';
import '../../database/local/local_agency.dart';
import '../../enums/user/user_designation.dart';
import '../../functions/bottom_sheet.dart';
import '../../functions/helping_funcation.dart';
import '../../models/agency/agency.dart';
import '../../models/agency/member_detail.dart';
import '../../widgets/custom/custom_list_tile_widget.dart';
import '../../widgets/custom/custom_square_photo.dart';
import '../../widgets/custom/show_loading.dart';

class AgencyDetailsScreen extends StatefulWidget {
  const AgencyDetailsScreen({Key? key}) : super(key: key);
  static const String routeName = '/agency-detail';

  @override
  State<AgencyDetailsScreen> createState() => _AgencyDetailsScreenState();
}

class _AgencyDetailsScreenState extends State<AgencyDetailsScreen> {
  bool needUpdate = false;

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  _dispose() async {
    Agency? agency = await LocalAgency()
        .agency(ModalRoute.of(context)!.settings.arguments as String);
    if (agency == null) return;
    await AgencyAPI().updateProfileInfo(agency);
  }

  @override
  Widget build(BuildContext context) {
    final String agencyID =
        ModalRoute.of(context)!.settings.arguments as String;
    // TODO: On Edit
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: needUpdate ? () => Navigator.of(context).pop() : null,
            child: const Text('Save'),
          ),
        ],
      ),
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
                      onEdit: () => onEditName(agency),
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
                    CustomListTileWidget(
                      leadingIcon: CupertinoIcons.globe,
                      header: 'Website',
                      title: agency.websiteURL,
                      canEdit: canEdit,
                      onEdit: () => onEditWebsite(agency),
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

  onEditName(Agency agency) async {
    final String? result = await BottomSheetFun().editableSheet(
      context,
      displayTitle: 'Agency Name',
      initText: agency.name,
    );
    if (result == null) return;
    setState(() {
      agency.name = result;
      needUpdate = true;
      agency.save();
    });
  }

  onEditWebsite(Agency agency) async {
    final String? result = await BottomSheetFun().editableSheet(
      context,
      displayTitle: 'Agency Website',
      initText: agency.websiteURL,
    );
    if (result == null) return;
    setState(() {
      agency.websiteURL = result;
      needUpdate = true;
      agency.save();
    });
  }
}
