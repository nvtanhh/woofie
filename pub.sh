#!/usr/bin/env bash

flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run easy_localization:generate -f keys -O lib -o locale_keys.g.dart
flutter format  lib/* test/* -l 150
