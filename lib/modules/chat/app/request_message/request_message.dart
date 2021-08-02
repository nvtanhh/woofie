import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:meowoof/core/helpers/format_helper.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/chat/app/request_message/request_message_model.dart';
import 'package:meowoof/modules/chat/domain/models/request_contact.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class RequestMessagePage extends StatefulWidget {
  @override
  _RequestMessagePageState createState() => _RequestMessagePageState();
}

class _RequestMessagePageState extends BaseViewState<RequestMessagePage, RequestMessagePageModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: viewModel.onRefresh,
        child: PagedListView<int, RequestContact>(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
          pagingController: viewModel.pagingController,
          builderDelegate: PagedChildBuilderDelegate<RequestContact>(
            itemBuilder: (context, requestMessage, index) {
              return ListTile(
                leading: MWAvatar(
                  avatarUrl: requestMessage.fromUser?.avatarUrl,
                  customSize: 50.w,
                ),
                title: Text(
                  requestMessage.fromUser?.name ?? "",
                  style: UITextStyle.text_body_16_w700,
                ),
                subtitle: Text(
                  "${requestMessage.content??""} (${FormatHelper.formatDateTime(requestMessage.createdAt, pattern: "dd/MM/yyyy")})",
                  style: UITextStyle.text_body_16_w700,
                ),
                trailing: Column(
                  children: [
                    InkWell(
                      onTap: () => viewModel.acceptRequest(requestMessage),
                      child: const Icon(
                        Icons.check_circle,
                        color: UIColor.primary,
                      ),
                    ),
                    InkWell(
                      onTap: () => viewModel.denyRequest(requestMessage, index),
                      child: const Icon(
                        Icons.dangerous,
                        color: UIColor.danger,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
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
        'Danh sách chờ',
        maxLines: 1,
        style: UITextStyle.text_header_24_w600,
      ),
    );
  }

  @override
  RequestMessagePageModel createViewModel() => injector<RequestMessagePageModel>();
}
