import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/domain/models/chat_room.dart';
import 'package:meowoof/modules/chat/presentation/pages/chat_dashboard_model.dart';
import 'package:meowoof/modules/chat/presentation/widgets/chat_room_item.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatDashboard extends StatefulWidget {
  const ChatDashboard({Key? key}) : super(key: key);

  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState extends BaseViewState<ChatDashboard, ChatManagerModel> {
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
        'Nhắn tin',
        maxLines: 1,
        style: GoogleFonts.montserrat(textStyle: UITextStyle.text_header_24_w600),
      ),
      actions: <Widget>[
        IconButton(
          icon: MWIcon(MWIcons.createChat),
          onPressed: viewModel.onWantsToCreateNewChat,
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
            () => ChatRoomItem(room: room.updateSubjectValue as ChatRoom),
          ),
        ),
      ),
    );
  }
}
