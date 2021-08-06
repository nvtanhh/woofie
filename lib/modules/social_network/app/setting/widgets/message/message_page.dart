import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/setting/widgets/message/message_page_model.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends BaseViewState<MessagePage, MessagePageModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cài đăt tin nhắn",
          style: UITextStyle.text_header_24_w600,
        ),
      ),
      body: Column(
        children: [
          Obx(
            () => RadioListTile<int>(
              value: 1,
              groupValue: viewModel.statusMessage,
              onChanged: (_) => viewModel.onLangSelected(_),
              title: Text(LocaleKeys.setting_message_public.trans(), style: UITextStyle.text_body_14_w500),
            ),
          ),
          Obx(
            () => RadioListTile<int>(
              value: 0,
              groupValue: viewModel.statusMessage,
              onChanged: (_) => viewModel.onLangSelected(_),
              title: Text(
                LocaleKeys.setting_message_private.trans(),
                style: UITextStyle.text_body_14_w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  MessagePageModel createViewModel() => injector<MessagePageModel>();
}
