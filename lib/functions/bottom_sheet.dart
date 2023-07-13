import 'package:flutter/material.dart';

import '../widgets/custom/custom_text_editable_widget.dart';

class BottomSheetFun {
  Future<String?> editableSheet(
    BuildContext context, {
    required String displayTitle,
    required String initText,
  }) async {
    return await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CustomTextEditableWidget(
          displayTitle: displayTitle,
          initText: initText,
        );
      },
    );
  }
}
