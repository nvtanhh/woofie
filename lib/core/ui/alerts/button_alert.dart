import 'package:flutter/material.dart';
import 'package:meowoof/assets.gen.dart';
import 'package:meowoof/core/ui/alerts/alert.dart';
import 'package:meowoof/core/ui/button.dart';
import 'package:meowoof/core/ui/icon.dart';

class MWButtonAlert extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final MWIconData? buttonIcon;
  final String buttonText;
  final AssetGenImage? assetImage;
  final MWButtonAlertTheme theme;

  const MWButtonAlert(
      {required this.onPressed,
      required this.text,
      required this.buttonText,
      this.isLoading = false,
      this.buttonIcon,
      this.assetImage,
      this.theme = MWButtonAlertTheme.light});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: MWAlert(
        child: Row(children: [
          if (assetImage != null)
            Padding(
                padding: const EdgeInsets.only(
                    right: 30, left: 10, top: 10, bottom: 10),
                child: assetImage!.image())
          else
            const SizedBox(),
          Flexible(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MWButton(
                  isLoading: isLoading,
                  onPressed: onPressed,
                  child: Text(buttonText),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}

enum MWButtonAlertTheme { dark, light }
