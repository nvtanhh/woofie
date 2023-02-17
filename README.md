# meowoof

Social network for pet

## How to run app?

```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run easy_localization:generate -f keys -O lib -o locale_keys.g.dart

flutter packages pub run build_runner build
```

### Notes

Flutter version 2.5.0
