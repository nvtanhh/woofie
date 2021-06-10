#!/usr/bin/env bash

fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter pub run easy_localization:generate -f keys -O lib -o locale_keys.g.dart
fvm flutter format  lib/* test/* -l 150
