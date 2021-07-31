import 'package:flutter/material.dart';
import 'package:meowoof/core/services/dialog_service.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/chat/app/widgets/active_status_avatar.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_body.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class MessageWidget extends StatelessWidget {
  final Message message;
  final User? chatPartner;
  final bool isDisplayAvatar;

  final Function(Message)? onMessageTap;

  const MessageWidget(this.message, {this.chatPartner, Key? key, this.isDisplayAvatar = true, this.onMessageTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMyMessage = message.isSentByMe;

    const double _messageBorderRadius = 15;
    final _borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular((isMyMessage || !isDisplayAvatar) ? _messageBorderRadius : 0),
      bottomRight: Radius.circular(isMyMessage
          ? !isDisplayAvatar
              ? _messageBorderRadius
              : 0
          : _messageBorderRadius),
      topLeft: const Radius.circular(_messageBorderRadius),
      topRight: const Radius.circular(_messageBorderRadius),
    );
    return Container(
      margin: const EdgeInsets.only(
        bottom: 4,
      ),
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isMyMessage) _buildMessageIdentifierAvatar(),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.65.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _onMessageTap(context),
                  child: ClipRRect(
                    borderRadius: _borderRadius,
                    child: Opacity(
                      opacity: message.isSent ? 1 : 0.6,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isMyMessage ? UIColor.primary : UIColor.holder,
                        ),
                        child: MessageBody(message, isMyMessage: isMyMessage, partner: chatPartner),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageIdentifierAvatar() {
    final avatarUrl = chatPartner?.avatarUrl ?? '';
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: isDisplayAvatar
          ? Transform.translate(
              offset: const Offset(0, 0.5),
              child: ActiveStatusAvatar(
                avatarUrl: avatarUrl,
                isSmallSize: true,
                borderRadius: 8,
                isActive: false,
              ),
            )
          : SizedBox(
              width: ScreenUtil().setWidth(MWAvatar.AVATAR_SIZE_SMALL),
            ),
    );
  }

  void _onMessageTap(BuildContext context) {
    if (message.isSent) {
      switch (message.type) {
        case MessageType.image:
          injector<DialogService>().showZoomablePhotoBoxView(
            imageUrl: message.content,
            context: context,
          );
          break;
        case MessageType.video:
          injector<DialogService>().showVideo(
            videoUrl: message.content,
            context: context,
          );
          break;
        default:
      }
    }
  }
}
