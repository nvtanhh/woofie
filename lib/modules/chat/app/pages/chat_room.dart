import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/app/pages/chat_room_model.dart';
import 'package:meowoof/modules/chat/app/widgets/chat_room_nav/chat_room_nav.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_item.dart';
import 'package:meowoof/modules/chat/app/widgets/message_sender.dart';
import 'package:suga_core/suga_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoom room;

  const ChatRoomPage(this.room, {Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState
    extends BaseViewState<ChatRoomPage, ChatRoomPageModel> {
  @override
  ChatRoomPageModel createViewModel() => injector<ChatRoomPageModel>();

  @override
  void loadArguments() {
    viewModel.room = widget.room;
    viewModel.messages = widget.room.messages.obs;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: ChatRoomNav(viewModel.room),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              controller: viewModel.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: viewModel.messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final bool isDisplayAvatar =
                    viewModel.checkIsDisplayAvatar(index);
                return MessageWidget(
                  viewModel.messages[index],
                  key: ObjectKey(viewModel.messages[index]),
                  chatPartner: viewModel.room.privateChatPartner,
                  isDisplayAvatar: isDisplayAvatar,
                );
              },
            ),
          ),
        ),
        _buildMessageSender(),
      ],
    );
  }

  Widget _buildMessageSender() {
    return Padding(
      padding: EdgeInsets.only(
        right: 16.w,
        left: 16.w,
        top: 16.h,
        bottom: 16.h,
      ),
      child: Obx(
        () => MessageSender(
          textController: viewModel.messageSenderTextController,
          onMediaPicked: viewModel.onMediaPicked,
          seendingMedias: viewModel.sendingMedias,
          onRemoveSeedingMedia: viewModel.onRemoveSeedingMedia,
          onSendMessage: viewModel.onSendMessage,
          isCanSendMessage: viewModel.isCanSendMessage,
          onTap: viewModel.scrollToBottom,
        ),
      ),
    );
  }
}
