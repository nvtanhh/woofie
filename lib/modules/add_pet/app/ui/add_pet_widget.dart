import 'package:flutter/material.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/add_pet/app/ui/add_pet_widget_model.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class AddPetWidget extends StatefulWidget {
  @override
  _AddPetWidgetState createState() => _AddPetWidgetState();
}

class _AddPetWidgetState extends BaseViewState<AddPetWidget, AddPetWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: UIColor.white,
        appBar: AppBar(
          backgroundColor: UIColor.white,
          title: Text(
            LocaleKeys.add_pet_add_pet.trans(),
            style: UITextStyle.text_header_24_w600,
          ),
          elevation: 0,
        ),
        body: Column(
          children: [

          ],
        ),
      ),
    );
  }

  @override
  AddPetWidgetModel createViewModel() => AddPetWidgetModel();
}
