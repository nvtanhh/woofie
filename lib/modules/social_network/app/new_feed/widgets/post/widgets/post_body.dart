import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_text_style.dart';

import './images_view_widget.dart';

class PostBody extends StatelessWidget {
  final Post post;
  const PostBody({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagesViewWidget(
          medias: post.medias ?? [],
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Text(
            post.content ?? "",
            style: UITextStyle.body_14_reg,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
