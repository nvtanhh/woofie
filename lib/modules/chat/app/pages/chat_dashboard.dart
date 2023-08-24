import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/extensions/string_ext.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/locale_keys.g.dart';
import 'package:meowoof/modules/chat/app/pages/chat_dashboard_model.dart';
import 'package:meowoof/modules/chat/app/widgets/chat_room_item.dart';
import 'package:meowoof/modules/chat/app/widgets/icon_with_bage_widget.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class ChatDashboard extends StatefulWidget {
  const ChatDashboard({super.key});

  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState
    extends BaseViewState<ChatDashboard, ChatManagerModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const MWIcon(
          MWIcons.back,
          color: UIColor.black,
        ),
        onPressed: () {
          Get.back();
        },
      ),
      centerTitle: true,
      title: Text(
        LocaleKeys.chat_dashboard_tile.trans(),
        maxLines: 1,
        style:
            GoogleFonts.montserrat(textStyle: UITextStyle.text_header_24_w600),
      ),
      actions: <Widget>[
        Obx(
          () => IconWithBagedWidget(
            goToRequestMessagePage: viewModel.goToRequestMessagePage,
            count: viewModel.countUserRequestMessage,
          ),
        )
      ],
    );
  }

  @override
  ChatManagerModel createViewModel() => injector<ChatManagerModel>();

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: viewModel.onRefresh,
      child: PagedListView<int, ChatRoom>(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        pagingController: viewModel.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ChatRoom>(
          itemBuilder: (context, room, index) => Obx(
            () => ChatRoomItem(
              key: Key(room.id),
              room: room.updateSubjectValue as ChatRoom,
              onChatRoomPressed: () => viewModel.onChatRoomPressed(room),
            ),
          ),
        ),
      ),
    );
  }
}
