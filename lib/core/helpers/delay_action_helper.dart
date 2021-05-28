import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

class DelayActionHelper {
  int milliseconds;
  late VoidCallback action;
  Timer? _timer;

  DelayActionHelper({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
