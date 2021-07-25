import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/presentation/pages/chat_room_model.dart';
import 'package:meowoof/modules/chat/presentation/widgets/chat_room_nav/chat_room_nav.dart';
import 'package:meowoof/modules/chat/presentation/widgets/message/message_item.dart';
import 'package:meowoof/modules/chat/presentation/widgets/message_sender.dart';
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
    viewModel.messages = widget.room.messages.toList().obs;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: _buildMessage(),
      bottomNavigationBar: _buildMessageSender(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: ChatRoomNav(viewModel.room),
    );
  }

  Widget _buildMessage() {
    return Obx(
      () => ListView.builder(
        controller: viewModel.scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: viewModel.messages.length,
        itemBuilder: (context, index) {
          final bool isDisplayAvatar = viewModel.checkIsDisplayAvatar(index);
          return MessageWidget(
            viewModel.messages[index],
            key: ObjectKey(viewModel.messages[index].objectId),
            chatPartner: viewModel.room.privateChatPartner,
            isDisplayAvatar: isDisplayAvatar,
          );
        },
      ),
    );
  }

  Widget _buildMessageSender() {
    return Padding(
      padding: EdgeInsets.only(
        right: 16.w,
        left: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
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
