import 'package:flutter/material.dart';
import 'package:meowoof/injector.dart';
import 'package:meowoof/modules/social_network/app/save_post/new_post_uploader_model.dart';
import 'package:meowoof/modules/social_network/domain/models/post/new_post_data.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
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

class _NewPostUploaderState
    extends BaseViewState<NewPostUploader, NewPostUploaderModel> {
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
    return const SizedBox();
  }
}
