import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meowoof/theme/ui_color.dart';

class MWSearchBar extends StatefulWidget {
  final MWSearchBarOnSearch onSearch;
  final VoidCallback? onCancel;
  final String? hintText;
  final Widget? filter;
  final bool? searchWidget;

  const MWSearchBar(
      {Key? key,
      required this.onSearch,
      this.hintText,
      this.onCancel,
      this.filter,
      this.searchWidget = false})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _textController = TextEditingController();
    _textController.addListener(() {
      widget.onSearch(_textController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = _textController.text.isNotEmpty;
    final EdgeInsetsGeometry inputContentPadding = EdgeInsets.only(
        top: 8.h, bottom: 8.h, left: 20.w, right: hasText ? 40.w : 20.w);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: UIColor.holder),
              child: Stack(
                children: <Widget>[
                  if (widget.searchWidget == false)
                    TextField(
                      textInputAction: TextInputAction.go,
                      focusNode: _textFocusNode,
                      controller: _textController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Icon(Icons.search),
                        ),
                        prefixIconConstraints:
                            BoxConstraints(maxWidth: 40.w, maxHeight: 20.h),
                        hintText: widget.hintText,
                        hintStyle:
                            TextStyle(color: Colors.grey[500], fontSize: 15.sp),
                        contentPadding: inputContentPadding,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      autocorrect: true,
                      maxLines: 1,
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
                            hintStyle: TextStyle(
                                color: Colors.grey[500], fontSize: 15.sp),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            suffixIcon: (!hasText)
                                ? const Icon(Icons.add)
                                : const SizedBox()),
                      ),
                    ),
                  if (hasText)
                    Positioned(
                      right: 0,
                      child: _buildClearButton(),
                    )
                  else
                    const SizedBox()
                ],
              ),
            ),
          ),
          widget.filter ?? const SizedBox(height: 0, width: 0),
          if (hasText)
            _buildCancelButton()
          else
            const SizedBox(
                // width: 15.0,
                )
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
          size: 15.sp,
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
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      minimumSize: Size(44.w, 44.h),
      backgroundColor: Colors.grey,
      padding: const EdgeInsets.all(5),
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: _cancelSearch,
      child: const Text(
        'Cancel',
      ),
    );
  }
}

typedef MWSearchBarOnSearch = void Function(String searchString);
