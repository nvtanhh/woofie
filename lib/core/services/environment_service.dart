import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@singleton
class EnvironmentService {
  late final String baseUrl;
  late final String hasuraUrl;
  late final String chatUrl;
  late final String s3Url;
  late final String onesignalAppId;

  Future<void> init() async {
    await dotenv.load();
    hasuraUrl = dotenv.env['HASURA_URL']!;
    chatUrl = dotenv.env['CHAT_URL']!;
    s3Url = dotenv.env['S3_URL']!;
    onesignalAppId = dotenv.env['ONESIGNAL_APP_ID']!;
  }
}
