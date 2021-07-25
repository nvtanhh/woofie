import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/image_with_placeholder_widget.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/item_tag_user_widget.dart';
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/send_comment/send_comment_widget_model.dart';
import 'package:meowoof/modules/social_network/domain/models/post/comment.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';
import 'package:type_ahead_text_field/type_ahead_text_field.dart';

class SendCommentWidget extends StatefulWidget {
  final Function(Comment) onSendComment;
  final Post post;
  final Comment? comment;

  const SendCommentWidget({
    Key? key,
    required this.onSendComment,
    required this.post,
    this.comment,
  }) : super(key: key);

  @override
  _SendCommentWidgetState createState() => _SendCommentWidgetState();
}

class _SendCommentWidgetState extends BaseViewState<SendCommentWidget, SendCommentWidgetModel> {
  @override
  void loadArguments() {
    viewModel.post = widget.post;
    viewModel.comment = widget.comment;
    viewModel.onSendComment = widget.onSendComment;
    viewModel.showSuggestionDialog = showSuggestionDialog;
    viewModel.customSpan = customSpan;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: UIColor.pinkSwan27,
            offset: Offset(0, -2),
            blurRadius: 5,
          )
        ],
        color: UIColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Row(
        children: [
          Obx(
            () {
              if (viewModel.user?.updateSubjectValue == null) {
                return Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetGenImage("resources/icons/ic_person.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              } else {
                return ImageWithPlaceHolderWidget(
                  width: 45.w,
                  height: 45.w,
                  fit: BoxFit.fill,
                  imageUrl: viewModel.user?.avatarUrl ?? "",
                  radius: 10.r,
                );
              }
            },
          ),
          SizedBox(
            width: 10.w,
          ),
          SizedBox(
            width: 250.w,
            child: TextField(
              key: viewModel.tfKey,
              decoration: InputDecoration(
                hintText: LocaleKeys.new_feed_write_a_comment.trans(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none),
                fillColor: UIColor.holder,
                focusColor: UIColor.black,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 2.h,
                  horizontal: 5.w,
                ),
              ),
              minLines: 1,
              onEditingComplete: () {
                viewModel.removeOverlay();
              },
              maxLines: 3,
              onSubmitted: (_) => viewModel.onSubmitted(),
              controller: viewModel.controller,
              scrollController: viewModel.controller?.scrollController,
              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: UIColor.primary,
              size: 30.w,
            ),
            onPressed: () => viewModel.onSendCommentClick(),
            constraints: const BoxConstraints(),
          )
        ],
      ),
    );
  }

  TextSpan customSpan(SuggestedDataWrapper<User> data) {
    return TextSpan(
      text: data.item?.name ?? "",
      style: const TextStyle(color: Colors.blue),
      // recognizer: readOnly
      //     ? (TapGestureRecognizer()
      //   ..onTap = () {
      //     showAboutDialog(context: Get.context!, children: [Text('${data.prefix}${data.id}')]);
      //   })
      //     : null,
    );
  }

  void showSuggestionDialog() {
    viewModel.overlayEntry = OverlayEntry(
      builder: (context) {
        Offset? offset;
        offset = viewModel.controller!.calculateGlobalOffset(
          context,
          viewModel.filterState?.offset,
          dialogHeight: 250,
          dialogWidth: 250.w,
        );
        return offset != null
            ? Stack(
                children: [
                  AnimatedPositioned(
                    key: viewModel.suggestionWidgetKey,
                    duration: const Duration(milliseconds: 300),
                    left: 60.w,
                    top: offset.dy,
                    child: Material(
                      color: Colors.transparent,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: UIColor.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        height: 250.h,
                        width: 250.w,
                        child: Column(
                          children: [
                            Container(
                              height: 40.h,
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    viewModel.removeOverlay();
                                  },
                                  icon: const Icon(Icons.close)),
                            ),
                            Text('Filter: ${viewModel.filterState?.text}'),
                            Flexible(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(minHeight: 200),
                                child: Obx(
                                  () => ListView.builder(
                                    itemBuilder: (context, index) {
                                      final item = viewModel.dataFilter[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (!viewModel.isTagedUser(item.item!)) {
                                            viewModel.controller?.approveSelection(viewModel.filterState!, item);
                                            viewModel.addTagUser(item.item!);
                                          }
                                          viewModel.removeOverlay();
                                        },
                                        child: ItemTagUserWidget(
                                          user: item.item!,
                                        ),
                                      );
                                    },
                                    itemCount: viewModel.dataFilter.length,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container();
      },
    );

    Overlay.of(Get.context!)?.insert(viewModel.overlayEntry!);
  }

  @override
  SendCommentWidgetModel createViewModel() => injector<SendCommentWidgetModel>();
}
