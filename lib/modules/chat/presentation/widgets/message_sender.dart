import 'package:flutter/material.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageSender extends StatelessWidget {
  final TextEditingController textController;

  const MessageSender({Key? key, required this.textController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: UIColor.holder,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const IconButton(
          onPressed: null,
          icon: MWIcon(MWIcons.camera),
        ),
        title: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Soạn tin nhắn...',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
        trailing: const IconButton(
          icon: Icon(
            Icons.send,
            color: UIColor.primary,
          ),
          onPressed: null,
        ),
      ),
    );
  }
}
