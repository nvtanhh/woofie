import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meowoof/core/ui/icon.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/new_post_uploader_model.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:meowoof/theme/ui_color.dart';
import 'package:suga_core/suga_core.dart';

class NewPostUploader extends StatefulWidget {
  final NewPostData data;
  final Function(Post, NewPostData) onPostPublished;
  final Function(NewPostData) onCancelled;

  const NewPostUploader({
    Key? key,
    required this.data,
    required this.onPostPublished,
    required this.onCancelled,
  }) : super(key: key);

  @override
  _NewPostUploaderState createState() => _NewPostUploaderState();
}

class _NewPostUploaderState extends BaseViewState<NewPostUploader, NewPostUploaderModel> {
  @override
  NewPostUploaderModel createViewModel() => injector<NewPostUploaderModel>();

  @override
  void loadArguments() {
    viewModel.data = widget.data;
    viewModel.onPostPublished = widget.onPostPublished;
    viewModel.onCancelled = widget.onCancelled;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowItems = [];

    if (widget.data.hasMedia()) {
      rowItems.addAll([
        _buildMediaPreview(),
        const SizedBox(
          width: 15,
        ),
      ]);
    }
    rowItems.addAll([
      _buildStatusText(),
      Obx(
        () => _buildActionButtons(),
      ),
    ]);

    return DecoratedBox(
      decoration: const BoxDecoration(color: UIColor.holder),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(children: rowItems),
                    ],
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => Positioned(
              bottom: -3,
              left: 0,
              right: 0,
              child: viewModel.status.value == PostUploaderStatus.creatingPost ||
                      viewModel.status.value == PostUploaderStatus.compressingPostMedia ||
                      viewModel.status.value == PostUploaderStatus.addingPostMedia ||
                      viewModel.status.value == PostUploaderStatus.processing
                  ? _buildProgressBar()
                  : const SizedBox(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    return FutureBuilder(
      future: viewModel.getMediaThumbnail(),
      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
        if (snapshot.data == null) return const SizedBox();

        final File? mediaThumbnail = snapshot.data;
        return mediaThumbnail != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: FileImage(mediaThumbnail),
                  height: viewModel.mediaPreviewSize,
                  width: viewModel.mediaPreviewSize,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox();
      },
    );
  }

  Widget _buildStatusText() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(
              () => Text(
                viewModel.statusMessage.value,
                textAlign: TextAlign.left,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final List<Widget> activeActions = [];

    switch (viewModel.status.value) {
      case PostUploaderStatus.creatingPost:
      case PostUploaderStatus.addingPostMedia:
        activeActions.add(_buildCancelButton());
        break;
      case PostUploaderStatus.failed:
        activeActions.add(_buildCancelButton());
        activeActions.add(_buildRetryButton());
        break;
      default:
    }

    return Row(
      children: activeActions,
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: viewModel.onWantsToCancel,
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: MWIcon(MWIcons.cancel),
      ),
    );
  }

  Widget _buildRetryButton() {
    return GestureDetector(
      onTap: viewModel.onWantsToRetry,
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: MWIcon(MWIcons.retry),
      ),
    );
  }

  Widget _buildProgressBar() {
    return const LinearProgressIndicator();
  }
}
