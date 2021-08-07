import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/app/pages/chat_room_model.dart';
import 'package:meowoof/modules/chat/app/widgets/chat_room_nav/chat_room_nav.dart';
import 'package:meowoof/modules/chat/app/widgets/message/message_item.dart';
import 'package:meowoof/modules/chat/app/widgets/message/typing_widget.dart';
import 'package:meowoof/modules/chat/app/widgets/message_sender.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/domain/models/message.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

class ChatRoomPage extends StatefulWidget {
  final ChatRoom? room;
  final User? partner;
  final Function(List<Message>)? onAddNewMessages;

  final Post? attachmentPost;

  const ChatRoomPage(
      {Key? key,
      this.room,
      this.partner,
      this.onAddNewMessages,
      this.attachmentPost})
      : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState
    extends BaseViewState<ChatRoomPage, ChatRoomPageModel> {
  @override
  ChatRoomPageModel createViewModel() => injector<ChatRoomPageModel>();

  @override
  void loadArguments() {
    viewModel.inputRoom = widget.room;
    viewModel.partner = widget.partner;
    viewModel.onAddNewMessages = widget.onAddNewMessages;
    viewModel.attachmentPost.value = widget.attachmentPost;
    super.loadArguments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => viewModel.isLoaded.value
          ? Scaffold(
              appBar: _buildAppBar(),
              body: _buildBody(),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
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
          child: PagedListView<int, Message>(
            scrollController: viewModel.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            pagingController: viewModel.pagingController,
            reverse: true,
            builderDelegate: PagedChildBuilderDelegate<Message>(
              itemBuilder: (context, message, index) {
                final bool isDisplayAvatar =
                    viewModel.checkIsDisplayAvatar(index);
                return MessageWidget(
                  message,
                  key: Key(message.id ?? message.createdAt.toString()),
                  chatPartner: viewModel.room.privateChatPartner,
                  isDisplayAvatar: isDisplayAvatar,
                );
              },
              noItemsFoundIndicatorBuilder: (_) => const SizedBox(),
            ),
          ),
        ),
        Obx(
          () => TypingWidget(
              isTyping: viewModel.partnerTypingStatus.value,
              chatPartner: viewModel.room.privateChatPartner),
        ),
        _buildMessageSender(),
      ],
    );
  }

  Widget _buildMessageSender() {
    return Padding(
      padding: EdgeInsets.only(
        right: 12.w,
        left: 12.w,
        top: 16.h,
        bottom: 16.h,
      ),
      child: Obx(
        () => MessageSender(
          textController: viewModel.messageSenderTextController,
          onMediaPicked: viewModel.onMediaPicked,
          previewMediaMessage: viewModel.sendingMedias,
          onRemoveSeedingMedia: viewModel.onRemoveSeedingMedia,
          onSendMessage: viewModel.onSendMessage,
          isCanSendMessage: viewModel.isCanSendMessage,
          onTap: viewModel.scrollToBottom,
          attachmentPost: viewModel.attachmentPost.value,
          onRemoveAttachmentPost: viewModel.onRemoveAttachmentPost,
        ),
      ),
    );
  }
}
