import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meowoof/theme/ui_color.dart';

class MWSearchBar extends StatefulWidget {
  final Function(String)? onSearch;
  final VoidCallback? onCancel;
  final String? hintText;
  final Widget? action;
  final bool? searchWidget;
  final Function(String)? onSubmitted;
  final String? textInit;

  const MWSearchBar({
    Key? key,
    this.onSearch,
    this.hintText,
    this.onCancel,
    this.action,
    this.searchWidget = false,
    this.onSubmitted,
    this.textInit,
  }) : super(key: key);

  @override
  MWSearchBarState createState() {
    return MWSearchBarState();
  }
}

class MWSearchBarState extends State<MWSearchBar> {
  late TextEditingController _textController;
  late FocusNode _textFocusNode;
  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey[200]!),
  );
  RxBool hasText = RxBool(false);

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _textController = TextEditingController(text: widget.textInit ?? "");
    _textController.addListener(() {
      if (_textController.text.isEmpty) {
        hasText.value = false;
      } else if (_textController.text.isNotEmpty && !hasText.value) {
        hasText.value = true;
      }
      widget.onSearch?.call(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: UIColor.holder),
              child: Stack(
                children: <Widget>[
                  if (widget.searchWidget == false)
                    TextField(
                      textInputAction: TextInputAction.go,
                      focusNode: _textFocusNode,
                      controller: _textController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: const Icon(Icons.search),
                        ),
                        prefixIconConstraints: BoxConstraints(maxWidth: 40.w, maxHeight: 20.h),
                        hintText: widget.hintText,
                        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15.sp),
                        contentPadding: EdgeInsets.only(
                          top: 8.h,
                          bottom: 8.h,
                          left: 20.w,
                          right: hasText.value ? 40.w : 20.w,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: widget.onSubmitted,
                    )
                  else
                    SizedBox(
                      height: 60.h,
                      child: TextField(
                        focusNode: _textFocusNode,
                        controller: _textController,
                        decoration: InputDecoration(
                          border: _outlineInputBorder,
                          focusedBorder: _outlineInputBorder,
                          errorBorder: _outlineInputBorder,
                          disabledBorder: _outlineInputBorder,
                          enabledBorder: _outlineInputBorder,
                          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15.sp),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          suffixIcon: (!hasText.value) ? const Icon(Icons.add) : const SizedBox(),
                        ),
                        onSubmitted: widget.onSubmitted,
                      ),
                    ),
                  Obx(() {
                    if (hasText.value) {
                      return Positioned(
                        right: 0,
                        child: _buildClearButton(),
                      );
                    } else {
                      return const SizedBox();
                    }
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: _clearText,
      child: SizedBox(
        height: 35.h,
        width: 35.w,
        child: Icon(
          Icons.close,
          size: 20.w,
        ),
      ),
    );
  }

  void _clearText() {
    _textController.clear();
  }

  void _cancelSearch() {
    // Unfocus text
    FocusScope.of(context).requestFocus(FocusNode());
    _textController.clear();
    if (widget.onCancel != null) widget.onCancel!();
  }

  Widget _buildCancelButton() {
    return const SizedBox();
    // final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    //   minimumSize: Size(44.w, 44.h),
    //   backgroundColor: Colors.grey,
    //   padding: const EdgeInsets.all(5),
    // );
    // return TextButton(
    //   style: flatButtonStyle,
    //   onPressed: _cancelSearch,
    //   child: const Text(
    //     'Cancel',
    //   ),
    // );
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }
}
