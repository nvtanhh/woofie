import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/avatar/avatar.dart';
import 'package:meowoof/core/ui/avatar/pet_avatar.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/confirm_functional_post/confirm_functional_post_model.dart';
import 'package:meowoof/modules/social_network/app/save_post/widgets/pet_card_item.dart';
import 'package:meowoof/modules/social_network/domain/models/pet/pet.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post_reaction.dart';
import 'package:meowoof/modules/social_network/domain/models/user.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:meowoof/theme/ui_text_style.dart';
import 'package:suga_core/suga_core.dart';

class ConfirmGivePet extends StatefulWidget {
  final Post post;
  const ConfirmGivePet({Key? key, required this.post}) : super(key: key);

  @override
  _ConfirmGivePetState createState() => _ConfirmGivePetState();
}

class _ConfirmGivePetState
    extends BaseViewState<ConfirmGivePet, ConfirmGivePetModel> {
  @override
  ConfirmGivePetModel createViewModel() => injector<ConfirmGivePetModel>();

  @override
  void loadArguments() {
    viewModel.post = widget.post;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: UIColor.white,
          elevation: 0,
          title: Text(
            viewModel.getAppbarTitle(),
            style: UITextStyle.text_header_18_w600,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const MWIcon(MWIcons.back),
            onPressed: () => Get.back(),
          ),
        ),
        body: FutureBuilder<List<PostReaction>>(
          future: viewModel.getAllUserInPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return _noUserFoundWidget();
              }
              if (widget.post.type == PostType.adop) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      _buildUserListItem(snapshot.data![index].reactor),
                );
              } else if (widget.post.type == PostType.mating) {
                return GridView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildMatingPetListItem(snapshot.data![index]),
                );
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildMatingPetListItem(PostReaction postReaction) {
    final pet = postReaction.matingPet;
    if (pet == null) return const SizedBox();
    final reactor = postReaction.reactor;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: PetCardItem(
            pet: pet,
            onClicked: () => viewModel.onTapMatingPetIteam(pet),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 3.w,
          child: MWAvatar(
            onPressed: () => viewModel.openUserProfile(reactor),
            avatarUrl: reactor.avatarUrl ?? '',
            borderRadius: 20.r,
            customSize: 24.w,
          ),
        )
      ],
    );
  }

  Widget _buildUserListItem(User user) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: GestureDetector(
        onTap: () => viewModel.openUserProfile(user),
        child: MWAvatar(
          avatarUrl: user.avatarUrl,
          borderRadius: 10.r,
        ),
      ),
      title: Text(
        user.name ?? '',
        style: UITextStyle.heading_16_semiBold,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(user.bio ?? ''),
      onTap: () => viewModel.onTapUser(user),
    );
  }

  Widget _noUserFoundWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          widget.post.type == PostType.adop
              ? 'Rất tiết chưa có ai nhận nuôi thú cưng của bạn.'
              : 'Rất tiết thú cưng của bạn chưa có yêu cầu ghép đôi nào.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
