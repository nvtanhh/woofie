import 'package:flutter/material.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/profile/medical_record/medical_record_model.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class MedicalRecord extends StatefulWidget {
  @override
  _MedicalRecordState createState() => _MedicalRecordState();
}

class _MedicalRecordState extends BaseViewState<MedicalRecord, MedicalRecordModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(LocaleKeys.profile_medical_record.trans(),style: UITextStyle.text_header_18_w700,),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }

  @override
  MedicalRecordModel createViewModel() => injector<MedicalRecordModel>();
}
