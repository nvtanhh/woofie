import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:meowoof/modules/social_network/domain/models/post/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suga_core/suga_core.dart';

@singleton
class NewfeedCacheStorage extends Storage<List<Post>> {
  NewfeedCacheStorage(SharedPreferences prefs)
      : super(prefs: prefs, key: "newfeed_cache");

  @override
  List<Post> get({List<Post> defaultValue = const []}) {
    final String? jsonString = prefs.getString(key);
    try {
      if (jsonString != null) {
        return (json.decode(jsonString) as List<dynamic>)
            .map((post) => Post.fromJson(post as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return defaultValue;
  }

  @override
  void set(List<Post> value) {
    final enCodedJson = value.map((e) => e.toJsonString()).toList().toString();
    prefs.setString(key, enCodedJson);
  }
}
