import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/setting/widgets/laguague/laguage_model.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class LanguageWidget extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState
    extends BaseViewState<LanguageWidget, LanguageWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            LocaleKeys.setting_language.trans(
                args: [viewModel.defineLanguage(viewModel.currentLanguage)]),
            style: UITextStyle.text_header_18_w600,
          ),
          leading: IconButton(
            icon: const MWIcon(MWIcons.back),
            onPressed: () => Get.back(result: viewModel.currentLanguage),
          ),
        ),
        body: Column(
          children: [
            RadioListTile<String>(
              value: 'vi',
              groupValue: viewModel.currentLanguage,
              onChanged: (_) => viewModel.onLangSelected(_, context),
              title: Text(LocaleKeys.setting_vietnamese.trans(),
                  style: UITextStyle.text_body_14_w500),
            ),
            RadioListTile<String>(
              value: 'en',
              groupValue: viewModel.currentLanguage,
              onChanged: (_) => viewModel.onLangSelected(_, context),
              title: Text(
                LocaleKeys.setting_english.trans(),
                style: UITextStyle.text_body_14_w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  LanguageWidgetModel createViewModel() => injector<LanguageWidgetModel>();
}
