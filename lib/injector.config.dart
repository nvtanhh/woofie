// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:event_bus/event_bus.dart' as _i7;
import 'package:firebase_auth/firebase_auth.dart' as _i10;
import 'package:firebase_core/firebase_core.dart' as _i9;
import 'package:flutter/material.dart' as _i19;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart' as _i8;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i12;
import 'package:hasura_connect/hasura_connect.dart' as _i32;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i17;
import 'package:meowoof/core/helpers/url_parser.dart' as _i28;
import 'package:meowoof/core/interceptors/jwt_interceptor.dart' as _i14;
import 'package:meowoof/core/logged_user.dart' as _i35;
import 'package:meowoof/core/services/bottom_sheet_service.dart' as _i3;
import 'package:meowoof/core/services/dialog_service.dart' as _i5;
import 'package:meowoof/core/services/environment_service.dart' as _i6;
import 'package:meowoof/core/services/httpie.dart' as _i13;
import 'package:meowoof/core/services/location_service.dart' as _i16;
import 'package:meowoof/core/services/media_service.dart' as _i20;
import 'package:meowoof/core/services/navigation_service.dart' as _i21;
import 'package:meowoof/core/services/toast_service.dart' as _i27;
import 'package:meowoof/injector.dart' as _i185;
import 'package:meowoof/modules/auth/app/ui/login/login_widget_model.dart'
    as _i158;
import 'package:meowoof/modules/auth/app/ui/register/register_widget_model.dart'
    as _i42;
import 'package:meowoof/modules/auth/app/ui/welcome/welcome_widget_model.dart'
    as _i107;
import 'package:meowoof/modules/auth/data/datasources/auth_datasource.dart'
    as _i30;
import 'package:meowoof/modules/auth/data/datasources/hasura_datasource.dart'
    as _i33;
import 'package:meowoof/modules/auth/data/repositories/auth_repository.dart'
    as _i51;
import 'package:meowoof/modules/auth/data/storages/newfeed_cache_storage.dart'
    as _i37;
import 'package:meowoof/modules/auth/data/storages/user_storage.dart' as _i29;
import 'package:meowoof/modules/auth/domain/usecases/get_user_with_uuid_usecase.dart'
    as _i69;
import 'package:meowoof/modules/auth/domain/usecases/login_email_password_usecase.dart'
    as _i72;
import 'package:meowoof/modules/auth/domain/usecases/login_with_facebook_usecase.dart'
    as _i73;
import 'package:meowoof/modules/auth/domain/usecases/login_with_google_usecase.dart'
    as _i74;
import 'package:meowoof/modules/auth/domain/usecases/logout_usecase.dart'
    as _i75;
import 'package:meowoof/modules/auth/domain/usecases/register_usecase.dart'
    as _i41;
import 'package:meowoof/modules/auth/domain/usecases/save_user_to_local_usecase.dart'
    as _i44;
import 'package:meowoof/modules/chat/app/pages/chat_dashboard_model.dart'
    as _i174;
import 'package:meowoof/modules/chat/app/pages/chat_room_model.dart' as _i116;
import 'package:meowoof/modules/chat/app/request_message/request_message_model.dart'
    as _i163;
import 'package:meowoof/modules/chat/data/datasources/chat_datasource.dart'
    as _i31;
import 'package:meowoof/modules/chat/data/datasources/request_contact_datasource.dart'
    as _i43;
import 'package:meowoof/modules/chat/data/repositories/chat_repository.dart'
    as _i52;
import 'package:meowoof/modules/chat/domain/usecases/message/get_messages_usecase.dart'
    as _i60;
import 'package:meowoof/modules/chat/domain/usecases/request_message/accept_request_message_usecase.dart'
    as _i108;
import 'package:meowoof/modules/chat/domain/usecases/request_message/count_user_request_message.dart'
    as _i54;
import 'package:meowoof/modules/chat/domain/usecases/request_message/deny_request_message_usecase.dart'
    as _i55;
import 'package:meowoof/modules/chat/domain/usecases/request_message/get_request_messages_from_user_usecase.dart'
    as _i66;
import 'package:meowoof/modules/chat/domain/usecases/request_message/get_request_messages_to_user_usecase.dart'
    as _i67;
import 'package:meowoof/modules/chat/domain/usecases/request_message/update_content_request_message_usecase.dart'
    as _i97;
import 'package:meowoof/modules/chat/domain/usecases/room/get_chat_rooms_usecase.dart'
    as _i57;
import 'package:meowoof/modules/chat/domain/usecases/room/get_messages_usecase.dart'
    as _i91;
import 'package:meowoof/modules/chat/domain/usecases/room/get_presined_url_usecase.dart'
    as _i65;
import 'package:meowoof/modules/chat/domain/usecases/room/init_chat_room_usecase.dart'
    as _i71;
import 'package:meowoof/modules/social_network/app/add_pet/add_pet_widget_model.dart'
    as _i172;
import 'package:meowoof/modules/social_network/app/explore/explore_widget_model.dart'
    as _i134;
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/adoption_pet_detail_widget_model.dart'
    as _i173;
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_pet_detail/confirm_functional_post/confirm_functional_post_model.dart'
    as _i176;
import 'package:meowoof/modules/social_network/app/explore/widgets/adoption_widget/adoption_widget_model.dart'
    as _i113;
import 'package:meowoof/modules/social_network/app/explore/widgets/search_wiget/search_widget_model.dart'
    as _i165;
import 'package:meowoof/modules/social_network/app/explore/widgets/service_detail/service_detail_page_model.dart'
    as _i183;
import 'package:meowoof/modules/social_network/app/home_menu/home_menu_model.dart'
    as _i155;
import 'package:meowoof/modules/social_network/app/map/map_searcher.dart'
    as _i18;
import 'package:meowoof/modules/social_network/app/map/map_searcher_model.dart'
    as _i179;
import 'package:meowoof/modules/social_network/app/map/widgets/filter/map_searcher_filter_model.dart'
    as _i76;
import 'package:meowoof/modules/social_network/app/new_feed/newfeed_widget_model.dart'
    as _i180;
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_bottom_sheet_widget_model.dart'
    as _i184;
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/comment_service.dart'
    as _i175;
import 'package:meowoof/modules/social_network/app/new_feed/widgets/comment/widgets/send_comment/send_comment_widget_model.dart'
    as _i166;
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_detail_widget_model.dart'
    as _i182;
import 'package:meowoof/modules/social_network/app/new_feed/widgets/post/post_service.dart'
    as _i161;
import 'package:meowoof/modules/social_network/app/notification/notification_widget_model.dart'
    as _i159;
import 'package:meowoof/modules/social_network/app/profile/edit_pet_profile/edit_pet_profile_model.dart'
    as _i177;
import 'package:meowoof/modules/social_network/app/profile/edit_user_profile/edit_user_profile_model.dart'
    as _i178;
import 'package:meowoof/modules/social_network/app/profile/medical_record/vaccinated/vaccinated_widget_model.dart'
    as _i169;
import 'package:meowoof/modules/social_network/app/profile/medical_record/weight/weight_model.dart'
    as _i170;
import 'package:meowoof/modules/social_network/app/profile/medical_record/worm_flushed/worm_flushed_model.dart'
    as _i171;
import 'package:meowoof/modules/social_network/app/profile/pet_profile/pet_profile_model.dart'
    as _i160;
import 'package:meowoof/modules/social_network/app/profile/pet_profile/widgets/detail_info_pet/detail_info_pet_widget_model.dart'
    as _i4;
import 'package:meowoof/modules/social_network/app/profile/user_profile/user_profile_model.dart'
    as _i168;
import 'package:meowoof/modules/social_network/app/save_post/new_post_uploader_model.dart'
    as _i181;
import 'package:meowoof/modules/social_network/app/save_post/save_post_model.dart'
    as _i164;
import 'package:meowoof/modules/social_network/app/setting/setting_model.dart'
    as _i93;
import 'package:meowoof/modules/social_network/app/setting/widgets/laguague/laguage_model.dart'
    as _i15;
import 'package:meowoof/modules/social_network/app/setting/widgets/message/setting_message_page_model.dart'
    as _i167;
import 'package:meowoof/modules/social_network/data/datasources/comment_datasource.dart'
    as _i53;
import 'package:meowoof/modules/social_network/data/datasources/location_datasource.dart'
    as _i34;
import 'package:meowoof/modules/social_network/data/datasources/media_datasource.dart'
    as _i36;
import 'package:meowoof/modules/social_network/data/datasources/notification_datasource.dart'
    as _i38;
import 'package:meowoof/modules/social_network/data/datasources/pet_datasource.dart'
    as _i39;
import 'package:meowoof/modules/social_network/data/datasources/post_datasource.dart'
    as _i40;
import 'package:meowoof/modules/social_network/data/datasources/service_datasource.dart'
    as _i45;
import 'package:meowoof/modules/social_network/data/datasources/setting_datasource.dart'
    as _i92;
import 'package:meowoof/modules/social_network/data/datasources/sound_datasource.dart'
    as _i26;
import 'package:meowoof/modules/social_network/data/datasources/storage_datasource.dart'
    as _i47;
import 'package:meowoof/modules/social_network/data/datasources/user_datasource.dart'
    as _i48;
import 'package:meowoof/modules/social_network/data/repositories/add_pet_repository.dart'
    as _i49;
import 'package:meowoof/modules/social_network/data/repositories/explore_repository.dart'
    as _i56;
import 'package:meowoof/modules/social_network/data/repositories/newfeed_repository.dart'
    as _i77;
import 'package:meowoof/modules/social_network/data/repositories/notification_repository.dart'
    as _i78;
import 'package:meowoof/modules/social_network/data/repositories/profile_repository.dart'
    as _i79;
import 'package:meowoof/modules/social_network/data/repositories/save_post_repository.dart'
    as _i87;
import 'package:meowoof/modules/social_network/data/repositories/setting_repository.dart'
    as _i94;
import 'package:meowoof/modules/social_network/data/storages/setting_storage.dart'
    as _i46;
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/add_pet_usecase.dart'
    as _i50;
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_breeds_usecase.dart'
    as _i61;
import 'package:meowoof/modules/social_network/domain/usecases/add_pet/get_pet_types_usecase.dart'
    as _i62;
import 'package:meowoof/modules/social_network/domain/usecases/explore/change_pet_owner.dart'
    as _i115;
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_detail_post_usecase.dart'
    as _i58;
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_functional_post_react.dart'
    as _i59;
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_post_by_location.dart'
    as _i63;
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_post_by_type_usecase.dart'
    as _i64;
import 'package:meowoof/modules/social_network/domain/usecases/explore/get_services_pet_usecase.dart'
    as _i68;
import 'package:meowoof/modules/social_network/domain/usecases/explore/had_found_pet_usecase.dart'
    as _i70;
import 'package:meowoof/modules/social_network/domain/usecases/explore/save_functional_post_react.dart'
    as _i86;
import 'package:meowoof/modules/social_network/domain/usecases/explore/search_pet_usecase.dart'
    as _i88;
import 'package:meowoof/modules/social_network/domain/usecases/explore/search_service_usecase.dart'
    as _i89;
import 'package:meowoof/modules/social_network/domain/usecases/explore/search_user_usecase.dart'
    as _i90;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/close_post_usecase.dart'
    as _i117;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/create_comment_usecase.dart'
    as _i119;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/create_post_usecase.dart'
    as _i122;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/delete_comment_usecase.dart'
    as _i124;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/edit_comment_usecase.dart'
    as _i132;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_all_user_in_post_usecase.dart'
    as _i136;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_comment_in_post_usecase.dart'
    as _i137;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_pets_of_user_usecase.dart'
    as _i140;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/get_posts_usecase.dart'
    as _i144;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_comment_usecase.dart'
    as _i156;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/like_post_usecase.dart'
    as _i157;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/play_sound_add_new_comment.dart'
    as _i22;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/play_sound_react_post.dart'
    as _i23;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/play_sound_receiver_comment.dart'
    as _i24;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/refresh_post_usecase.dart'
    as _i81;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/report_comment_usecase.dart'
    as _i82;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/report_post_usecase.dart'
    as _i83;
import 'package:meowoof/modules/social_network/domain/usecases/new_feed/subscription_comment_usecase.dart'
    as _i96;
import 'package:meowoof/modules/social_network/domain/usecases/notification/count_notification_unread_usecase.dart'
    as _i118;
import 'package:meowoof/modules/social_network/domain/usecases/notification/delete_notification_usecase.dart'
    as _i126;
import 'package:meowoof/modules/social_network/domain/usecases/notification/get_notifications_usecase.dart'
    as _i139;
import 'package:meowoof/modules/social_network/domain/usecases/notification/read_all_notification_usecase.dart'
    as _i80;
import 'package:meowoof/modules/social_network/domain/usecases/notification/update_token_notify_usecase.dart'
    as _i104;
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_vaccinated_usecase.dart'
    as _i110;
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_weights_usecase.dart'
    as _i111;
import 'package:meowoof/modules/social_network/domain/usecases/profile/add_worm_flushed_usecase.dart'
    as _i112;
import 'package:meowoof/modules/social_network/domain/usecases/profile/block_user_usecase.dart'
    as _i114;
import 'package:meowoof/modules/social_network/domain/usecases/profile/create_locaction_usecase.dart'
    as _i121;
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_usecase.dart'
    as _i127;
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_vaccinated_usecase.dart'
    as _i128;
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_weight_usecase.dart'
    as _i129;
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_pet_worm_flush_usecase.dart'
    as _i130;
import 'package:meowoof/modules/social_network/domain/usecases/profile/delete_post_usecase.dart'
    as _i131;
import 'package:meowoof/modules/social_network/domain/usecases/profile/follow_pet_usecase.dart'
    as _i135;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_detail_info_pet_usecase.dart'
    as _i138;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_posts_of_pet_usecase.dart'
    as _i143;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_posts_of_user_usecase.dart'
    as _i141;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_presigned_avatar_pet_url_usecase.dart'
    as _i145;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_presigned_avatar_url_usecase.dart'
    as _i146;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_user_profile_usecase.dart'
    as _i151;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_vaccinates_usecase.dart'
    as _i152;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_weights_usecase.dart'
    as _i153;
import 'package:meowoof/modules/social_network/domain/usecases/profile/get_worm_flushes_usecase.dart'
    as _i154;
import 'package:meowoof/modules/social_network/domain/usecases/profile/report_user_usecase.dart'
    as _i84;
import 'package:meowoof/modules/social_network/domain/usecases/profile/request_contact_usecase.dart'
    as _i85;
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_location_usecase.dart'
    as _i98;
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_infomation_usecase.dart'
    as _i99;
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_vaccinated_usecase.dart'
    as _i100;
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_weight_usecase.dart'
    as _i101;
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_pet_worm_flush_usecase.dart'
    as _i102;
import 'package:meowoof/modules/social_network/domain/usecases/profile/update_user_infomation_usecase.dart'
    as _i105;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/add_post_media_usecase.dart'
    as _i109;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/create_draft_post_usecase.dart'
    as _i120;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/delete_media_usecase.dart'
    as _i125;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/edit_post_usecase.dart'
    as _i133;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_post_status_usecase.dart'
    as _i142;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_presigned_url_usecase.dart'
    as _i147;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/get_published_post_usecase.dart'
    as _i148;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/publish_post_usecase.dart'
    as _i162;
import 'package:meowoof/modules/social_network/domain/usecases/save_post/upload_media_usecase.dart'
    as _i106;
import 'package:meowoof/modules/social_network/domain/usecases/setting/create_setting_usecase.dart'
    as _i123;
import 'package:meowoof/modules/social_network/domain/usecases/setting/get_setting_local_usecase.dart'
    as _i149;
import 'package:meowoof/modules/social_network/domain/usecases/setting/get_setting_remote_usecase.dart'
    as _i150;
import 'package:meowoof/modules/social_network/domain/usecases/setting/update_setting_usecase.dart'
    as _i103;
import 'package:meowoof/modules/splash/app/ui/splash_widget_model.dart' as _i95;
import 'package:shared_preferences/shared_preferences.dart'
    as _i25; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.BottomSheetService>(() => _i3.BottomSheetService());
    gh.factory<_i4.DetailInfoPetWidgetModel>(
        () => _i4.DetailInfoPetWidgetModel());
    gh.lazySingleton<_i5.DialogService>(() => _i5.DialogService());
    gh.singleton<_i6.EnvironmentService>(_i6.EnvironmentService());
    gh.lazySingleton<_i7.EventBus>(() => registerModule.getEventBus());
    gh.lazySingleton<_i8.FacebookAuth>(() => registerModule.getFacebookAuth());
    await gh.lazySingletonAsync<_i9.FirebaseApp>(
      () => registerModule.getFirebaseApp(),
      preResolve: true,
    );
    gh.lazySingleton<_i10.FirebaseAuth>(() => registerModule.getFirebaseAuth());
    gh.lazySingleton<_i11.FlutterLocalNotificationsPlugin>(
        () => registerModule.getFlutterLocalNotificationsPlugin());
    gh.lazySingleton<_i12.GoogleSignIn>(() => registerModule.getGoogleSignIn());
    gh.factory<_i13.HttpieService>(
        () => _i13.HttpieService(gh<_i10.FirebaseAuth>()));
    gh.lazySingleton<_i14.JwtInterceptor>(
        () => _i14.JwtInterceptor(gh<_i10.FirebaseAuth>()));
    gh.factory<_i15.LanguageWidgetModel>(() => _i15.LanguageWidgetModel());
    gh.lazySingleton<_i16.LocationService>(() => _i16.LocationService());
    gh.lazySingleton<_i17.Logger>(() => registerModule.getLogger());
    gh.factory<_i18.MapSearcher>(() => _i18.MapSearcher(key: gh<_i19.Key>()));
    gh.lazySingleton<_i20.MediaService>(() => _i20.MediaService());
    gh.lazySingleton<_i21.NavigationService>(() => _i21.NavigationService());
    gh.lazySingleton<_i22.PlaySoundAddNewComment>(
        () => _i22.PlaySoundAddNewComment(gh<_i7.EventBus>()));
    gh.lazySingleton<_i23.PlaySoundReactPost>(
        () => _i23.PlaySoundReactPost(gh<_i7.EventBus>()));
    gh.lazySingleton<_i24.PlaySoundReceiverComment>(
        () => _i24.PlaySoundReceiverComment(gh<_i7.EventBus>()));
    await gh.lazySingletonAsync<_i25.SharedPreferences>(
      () => registerModule.getSharePreferences(),
      preResolve: true,
    );
    gh.singleton<_i26.SoundDatasource>(
        _i26.SoundDatasource(gh<_i7.EventBus>()));
    gh.lazySingleton<_i27.ToastService>(() => _i27.ToastService());
    gh.factory<_i28.UrlParser>(() => _i28.UrlParser());
    gh.singleton<_i29.UserStorage>(
        _i29.UserStorage(gh<_i25.SharedPreferences>()));
    gh.lazySingleton<_i30.AuthDatasource>(() => _i30.AuthDatasource(
          gh<_i12.GoogleSignIn>(),
          gh<_i10.FirebaseAuth>(),
          gh<_i8.FacebookAuth>(),
          gh<_i29.UserStorage>(),
        ));
    gh.lazySingleton<_i31.ChatDatasource>(() => _i31.ChatDatasource(
          gh<_i13.HttpieService>(),
          gh<_i28.UrlParser>(),
        ));
    gh.lazySingleton<_i32.HasuraConnect>(
        () => registerModule.getHasuraConnect(gh<_i14.JwtInterceptor>()));
    gh.lazySingleton<_i33.HasuraDatasource>(
        () => _i33.HasuraDatasource(gh<_i32.HasuraConnect>()));
    gh.lazySingleton<_i34.LocationDatasource>(
        () => _i34.LocationDatasource(gh<_i32.HasuraConnect>()));
    gh.lazySingleton<_i35.LoggedInUser>(
        () => _i35.LoggedInUser(gh<_i29.UserStorage>()));
    gh.lazySingleton<_i36.MediaDatasource>(
        () => _i36.MediaDatasource(gh<_i32.HasuraConnect>()));
    gh.singleton<_i37.NewfeedCacheStorage>(
        _i37.NewfeedCacheStorage(gh<_i25.SharedPreferences>()));
    gh.lazySingleton<_i38.NotificationDatasource>(
        () => _i38.NotificationDatasource(gh<_i32.HasuraConnect>()));
    gh.lazySingleton<_i39.PetDatasource>(() => _i39.PetDatasource(
          gh<_i32.HasuraConnect>(),
          gh<_i35.LoggedInUser>(),
        ));
    gh.lazySingleton<_i40.PostDatasource>(() => _i40.PostDatasource(
          gh<_i32.HasuraConnect>(),
          gh<_i35.LoggedInUser>(),
        ));
    gh.lazySingleton<_i41.RegisterUsecase>(
        () => _i41.RegisterUsecase(gh<_i30.AuthDatasource>()));
    gh.factory<_i42.RegisterWidgetModel>(
        () => _i42.RegisterWidgetModel(gh<_i41.RegisterUsecase>()));
    gh.lazySingleton<_i43.RequestContactDatasource>(
        () => _i43.RequestContactDatasource(
              gh<_i32.HasuraConnect>(),
              gh<_i35.LoggedInUser>(),
            ));
    gh.lazySingleton<_i44.SaveUserToLocalUsecase>(
        () => _i44.SaveUserToLocalUsecase(gh<_i29.UserStorage>()));
    gh.lazySingleton<_i45.ServiceDatasource>(
        () => _i45.ServiceDatasource(gh<_i32.HasuraConnect>()));
    gh.singleton<_i46.SettingStorage>(
        _i46.SettingStorage(gh<_i25.SharedPreferences>()));
    gh.factory<_i47.StorageDatasource>(() => _i47.StorageDatasource(
          gh<_i28.UrlParser>(),
          gh<_i32.HasuraConnect>(),
          gh<_i13.HttpieService>(),
          gh<_i35.LoggedInUser>(),
        ));
    gh.lazySingleton<_i48.UserDatasource>(
        () => _i48.UserDatasource(gh<_i32.HasuraConnect>()));
    gh.lazySingleton<_i49.AddPetRepository>(
        () => _i49.AddPetRepository(gh<_i39.PetDatasource>()));
    gh.lazySingleton<_i50.AddPetUsecase>(() => _i50.AddPetUsecase(
          gh<_i49.AddPetRepository>(),
          gh<_i7.EventBus>(),
        ));
    gh.lazySingleton<_i51.AuthRepository>(() => _i51.AuthRepository(
          gh<_i30.AuthDatasource>(),
          gh<_i33.HasuraDatasource>(),
        ));
    gh.lazySingleton<_i52.ChatRepository>(() => _i52.ChatRepository(
          gh<_i31.ChatDatasource>(),
          gh<_i47.StorageDatasource>(),
          gh<_i43.RequestContactDatasource>(),
        ));
    gh.factory<_i53.CommentDatasource>(
        () => _i53.CommentDatasource(gh<_i32.HasuraConnect>()));
    gh.lazySingleton<_i54.CountUserRequestMessagesUsecase>(
        () => _i54.CountUserRequestMessagesUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i55.DenyRequestMessagesUsecase>(
        () => _i55.DenyRequestMessagesUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i56.ExploreRepository>(() => _i56.ExploreRepository(
          gh<_i40.PostDatasource>(),
          gh<_i39.PetDatasource>(),
          gh<_i48.UserDatasource>(),
          gh<_i45.ServiceDatasource>(),
        ));
    gh.lazySingleton<_i57.GetChatRoomsUseCase>(
        () => _i57.GetChatRoomsUseCase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i58.GetDetailPostUsecase>(
        () => _i58.GetDetailPostUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i59.GetFunctionalPostReactions>(
        () => _i59.GetFunctionalPostReactions(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i60.GetMessagesUseCase>(
        () => _i60.GetMessagesUseCase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i61.GetPetBreedUsecase>(
        () => _i61.GetPetBreedUsecase(gh<_i49.AddPetRepository>()));
    gh.lazySingleton<_i62.GetPetTypesUsecase>(
        () => _i62.GetPetTypesUsecase(gh<_i49.AddPetRepository>()));
    gh.lazySingleton<_i63.GetPostByLocationUsecase>(
        () => _i63.GetPostByLocationUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i64.GetPostByTypeUsecase>(
        () => _i64.GetPostByTypeUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i65.GetPresignedUrlForChatUsecase>(
        () => _i65.GetPresignedUrlForChatUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i66.GetRequestMessagesFromUserUsecase>(() =>
        _i66.GetRequestMessagesFromUserUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i67.GetRequestMessagesToUserUsecase>(
        () => _i67.GetRequestMessagesToUserUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i68.GetServicesPetUsecase>(
        () => _i68.GetServicesPetUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i69.GetUserWithUuidUsecase>(
        () => _i69.GetUserWithUuidUsecase(gh<_i51.AuthRepository>()));
    gh.lazySingleton<_i70.HadFoundPetUsecase>(
        () => _i70.HadFoundPetUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i71.InitChatRoomsUseCase>(
        () => _i71.InitChatRoomsUseCase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i72.LoginWithEmailPasswordUsecase>(
        () => _i72.LoginWithEmailPasswordUsecase(gh<_i51.AuthRepository>()));
    gh.lazySingleton<_i73.LoginWithFacebookUsecase>(
        () => _i73.LoginWithFacebookUsecase(gh<_i51.AuthRepository>()));
    gh.lazySingleton<_i74.LoginWithGoogleUsecase>(
        () => _i74.LoginWithGoogleUsecase(gh<_i51.AuthRepository>()));
    gh.lazySingleton<_i75.LogoutUsecase>(
        () => _i75.LogoutUsecase(gh<_i51.AuthRepository>()));
    gh.factory<_i76.MapSearcherFilterModel>(() => _i76.MapSearcherFilterModel(
          gh<_i62.GetPetTypesUsecase>(),
          gh<_i61.GetPetBreedUsecase>(),
        ));
    gh.lazySingleton<_i77.NewFeedRepository>(() => _i77.NewFeedRepository(
          gh<_i40.PostDatasource>(),
          gh<_i39.PetDatasource>(),
          gh<_i53.CommentDatasource>(),
        ));
    gh.lazySingleton<_i78.NotificationRepository>(
        () => _i78.NotificationRepository(
              gh<_i48.UserDatasource>(),
              gh<_i38.NotificationDatasource>(),
            ));
    gh.lazySingleton<_i79.ProfileRepository>(() => _i79.ProfileRepository(
          gh<_i48.UserDatasource>(),
          gh<_i39.PetDatasource>(),
          gh<_i40.PostDatasource>(),
          gh<_i34.LocationDatasource>(),
          gh<_i43.RequestContactDatasource>(),
        ));
    gh.lazySingleton<_i80.ReadAllNotificationUsecase>(() =>
        _i80.ReadAllNotificationUsecase(gh<_i78.NotificationRepository>()));
    gh.lazySingleton<_i81.RefreshPostsUsecase>(
        () => _i81.RefreshPostsUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i82.ReportCommentUsecase>(
        () => _i82.ReportCommentUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i83.ReportPostUsecase>(
        () => _i83.ReportPostUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i84.ReportUserUsecase>(
        () => _i84.ReportUserUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i85.RequestContactUsecase>(
        () => _i85.RequestContactUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i86.SaveFunctionalPostReact>(
        () => _i86.SaveFunctionalPostReact(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i87.SavePostRepository>(() => _i87.SavePostRepository(
          gh<_i40.PostDatasource>(),
          gh<_i47.StorageDatasource>(),
          gh<_i36.MediaDatasource>(),
        ));
    gh.lazySingleton<_i88.SearchPetUsecase>(
        () => _i88.SearchPetUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i89.SearchServiceUsecase>(
        () => _i89.SearchServiceUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i90.SearchUserUsecase>(
        () => _i90.SearchUserUsecase(gh<_i56.ExploreRepository>()));
    gh.lazySingleton<_i91.SendMessagesUsecase>(
        () => _i91.SendMessagesUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i92.SettingDatasource>(() => _i92.SettingDatasource(
          gh<_i32.HasuraConnect>(),
          gh<_i35.LoggedInUser>(),
          gh<_i46.SettingStorage>(),
        ));
    gh.factory<_i93.SettingModel>(
        () => _i93.SettingModel(gh<_i75.LogoutUsecase>()));
    gh.lazySingleton<_i94.SettingRepository>(
        () => _i94.SettingRepository(gh<_i92.SettingDatasource>()));
    gh.lazySingleton<_i95.SplashWidgetModel>(() => _i95.SplashWidgetModel(
          gh<_i10.FirebaseAuth>(),
          gh<_i29.UserStorage>(),
          gh<_i69.GetUserWithUuidUsecase>(),
        ));
    gh.lazySingleton<_i96.SubscriptionCommentUsecase>(
        () => _i96.SubscriptionCommentUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i97.UpdateContentRequestMessagesUsecase>(() =>
        _i97.UpdateContentRequestMessagesUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i98.UpdateLocationUsecase>(
        () => _i98.UpdateLocationUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i99.UpdatePetInformationUsecase>(
        () => _i99.UpdatePetInformationUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i100.UpdatePetVaccinatedUsecase>(
        () => _i100.UpdatePetVaccinatedUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i101.UpdatePetWeightUsecase>(
        () => _i101.UpdatePetWeightUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i102.UpdatePetWormFlushUsecase>(
        () => _i102.UpdatePetWormFlushUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i103.UpdateSettingUsecase>(
        () => _i103.UpdateSettingUsecase(gh<_i94.SettingRepository>()));
    gh.lazySingleton<_i104.UpdateTokenNotifyUsecase>(() =>
        _i104.UpdateTokenNotifyUsecase(gh<_i78.NotificationRepository>()));
    gh.lazySingleton<_i105.UpdateUserInformationUsecase>(
        () => _i105.UpdateUserInformationUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i106.UploadMediaUsecase>(
        () => _i106.UploadMediaUsecase(gh<_i87.SavePostRepository>()));
    gh.factory<_i107.WelcomeWidgetModel>(() => _i107.WelcomeWidgetModel(
          gh<_i74.LoginWithGoogleUsecase>(),
          gh<_i73.LoginWithFacebookUsecase>(),
          gh<_i69.GetUserWithUuidUsecase>(),
          gh<_i10.FirebaseAuth>(),
          gh<_i44.SaveUserToLocalUsecase>(),
          gh<_i104.UpdateTokenNotifyUsecase>(),
          gh<_i27.ToastService>(),
          gh<_i35.LoggedInUser>(),
          gh<_i46.SettingStorage>(),
        ));
    gh.lazySingleton<_i108.AcceptRequestMessagesUsecase>(
        () => _i108.AcceptRequestMessagesUsecase(gh<_i52.ChatRepository>()));
    gh.lazySingleton<_i109.AddPostMediaUsecase>(
        () => _i109.AddPostMediaUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i110.AddVaccinatedUsecase>(
        () => _i110.AddVaccinatedUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i111.AddWeightUsecase>(
        () => _i111.AddWeightUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i112.AddWormFlushedUsecase>(
        () => _i112.AddWormFlushedUsecase(gh<_i79.ProfileRepository>()));
    gh.factory<_i113.AdoptionWidgetModel>(() => _i113.AdoptionWidgetModel(
          gh<_i64.GetPostByTypeUsecase>(),
          gh<_i16.LocationService>(),
          gh<_i35.LoggedInUser>(),
        ));
    gh.lazySingleton<_i114.BlockUserUsecase>(
        () => _i114.BlockUserUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i115.ChangePetOwnerUsecase>(
        () => _i115.ChangePetOwnerUsecase(gh<_i56.ExploreRepository>()));
    gh.factory<_i116.ChatRoomPageModel>(() => _i116.ChatRoomPageModel(
          gh<_i20.MediaService>(),
          gh<_i65.GetPresignedUrlForChatUsecase>(),
          gh<_i106.UploadMediaUsecase>(),
          gh<_i60.GetMessagesUseCase>(),
          gh<_i91.SendMessagesUsecase>(),
          gh<_i10.FirebaseAuth>(),
          gh<_i71.InitChatRoomsUseCase>(),
          gh<_i86.SaveFunctionalPostReact>(),
        ));
    gh.lazySingleton<_i117.ClosePostUsecase>(
        () => _i117.ClosePostUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i118.CountNotificationUnreadUsecase>(() =>
        _i118.CountNotificationUnreadUsecase(
            gh<_i78.NotificationRepository>()));
    gh.lazySingleton<_i119.CreateCommentUsecase>(
        () => _i119.CreateCommentUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i120.CreateDraftPostUsecase>(
        () => _i120.CreateDraftPostUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i121.CreateLocationUsecase>(
        () => _i121.CreateLocationUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i122.CreatePostUsecase>(() => _i122.CreatePostUsecase(
          gh<_i77.NewFeedRepository>(),
          gh<_i7.EventBus>(),
        ));
    gh.lazySingleton<_i123.CreateSettingUsecase>(
        () => _i123.CreateSettingUsecase(gh<_i94.SettingRepository>()));
    gh.lazySingleton<_i124.DeleteCommentUsecase>(
        () => _i124.DeleteCommentUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i125.DeleteMediaUsecase>(
        () => _i125.DeleteMediaUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i126.DeleteNotificationUsecase>(() =>
        _i126.DeleteNotificationUsecase(gh<_i78.NotificationRepository>()));
    gh.lazySingleton<_i127.DeletePetUsecase>(
        () => _i127.DeletePetUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i128.DeletePetVaccinatedUsecase>(
        () => _i128.DeletePetVaccinatedUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i129.DeletePetWeightUsecase>(
        () => _i129.DeletePetWeightUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i130.DeletePetWormFlushUsecase>(
        () => _i130.DeletePetWormFlushUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i131.DeletePostUsecase>(
        () => _i131.DeletePostUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i132.EditCommentUsecase>(
        () => _i132.EditCommentUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i133.EditPostUsecase>(
        () => _i133.EditPostUsecase(gh<_i87.SavePostRepository>()));
    gh.factory<_i134.ExploreWidgetModel>(() => _i134.ExploreWidgetModel(
          gh<_i68.GetServicesPetUsecase>(),
          gh<_i98.UpdateLocationUsecase>(),
        ));
    gh.lazySingleton<_i135.FollowPetUsecase>(
        () => _i135.FollowPetUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i136.GetAllUserInPostUsecase>(
        () => _i136.GetAllUserInPostUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i137.GetCommentInPostUsecase>(
        () => _i137.GetCommentInPostUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i138.GetDetailInfoPetUsecase>(
        () => _i138.GetDetailInfoPetUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i139.GetNotificationUsecase>(
        () => _i139.GetNotificationUsecase(gh<_i78.NotificationRepository>()));
    gh.lazySingleton<_i140.GetPetsOfUserUsecase>(
        () => _i140.GetPetsOfUserUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i141.GetPostOfUserUsecase>(
        () => _i141.GetPostOfUserUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i142.GetPostStatusUsecase>(
        () => _i142.GetPostStatusUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i143.GetPostsOfPetUsecase>(
        () => _i143.GetPostsOfPetUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i144.GetPostsUsecase>(
        () => _i144.GetPostsUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i145.GetPresignedAvatarPetUrlUsecase>(() =>
        _i145.GetPresignedAvatarPetUrlUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i146.GetPresignedAvatarUrlUsecase>(() =>
        _i146.GetPresignedAvatarUrlUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i147.GetPresignedUrlUsecase>(
        () => _i147.GetPresignedUrlUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i148.GetPublishedPostUsecase>(
        () => _i148.GetPublishedPostUsecase(gh<_i87.SavePostRepository>()));
    gh.lazySingleton<_i149.GetSettingLocalUseacse>(
        () => _i149.GetSettingLocalUseacse(gh<_i94.SettingRepository>()));
    gh.lazySingleton<_i150.GetSettingUsecase>(
        () => _i150.GetSettingUsecase(gh<_i94.SettingRepository>()));
    gh.lazySingleton<_i151.GetUseProfileUseacse>(
        () => _i151.GetUseProfileUseacse(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i152.GetVaccinatesUsecase>(
        () => _i152.GetVaccinatesUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i153.GetWeightsUsecase>(
        () => _i153.GetWeightsUsecase(gh<_i79.ProfileRepository>()));
    gh.lazySingleton<_i154.GetWormFlushesUsecase>(
        () => _i154.GetWormFlushesUsecase(gh<_i79.ProfileRepository>()));
    gh.factory<_i155.HomeMenuWidgetModel>(() => _i155.HomeMenuWidgetModel(
          gh<_i118.CountNotificationUnreadUsecase>(),
          gh<_i80.ReadAllNotificationUsecase>(),
          gh<_i27.ToastService>(),
        ));
    gh.lazySingleton<_i156.LikeCommentUsecase>(
        () => _i156.LikeCommentUsecase(gh<_i77.NewFeedRepository>()));
    gh.lazySingleton<_i157.LikePostUsecase>(
        () => _i157.LikePostUsecase(gh<_i77.NewFeedRepository>()));
    gh.factory<_i158.LoginWidgetModel>(() => _i158.LoginWidgetModel(
          gh<_i72.LoginWithEmailPasswordUsecase>(),
          gh<_i69.GetUserWithUuidUsecase>(),
          gh<_i44.SaveUserToLocalUsecase>(),
          gh<_i35.LoggedInUser>(),
          gh<_i104.UpdateTokenNotifyUsecase>(),
        ));
    gh.factory<_i159.NotificationWidgetModel>(
        () => _i159.NotificationWidgetModel(
              gh<_i139.GetNotificationUsecase>(),
              gh<_i126.DeleteNotificationUsecase>(),
            ));
    gh.factory<_i160.PetProfileModel>(() => _i160.PetProfileModel(
          gh<_i138.GetDetailInfoPetUsecase>(),
          gh<_i135.FollowPetUsecase>(),
          gh<_i127.DeletePetUsecase>(),
          gh<_i7.EventBus>(),
        ));
    gh.factory<_i161.PostService>(() => _i161.PostService(
          gh<_i20.MediaService>(),
          gh<_i147.GetPresignedUrlUsecase>(),
          gh<_i106.UploadMediaUsecase>(),
          gh<_i133.EditPostUsecase>(),
          gh<_i157.LikePostUsecase>(),
          gh<_i3.BottomSheetService>(),
          gh<_i131.DeletePostUsecase>(),
          gh<_i27.ToastService>(),
          gh<_i81.RefreshPostsUsecase>(),
          gh<_i83.ReportPostUsecase>(),
          gh<_i23.PlaySoundReactPost>(),
          gh<_i98.UpdateLocationUsecase>(),
        ));
    gh.lazySingleton<_i162.PublishUsecase>(
        () => _i162.PublishUsecase(gh<_i87.SavePostRepository>()));
    gh.factory<_i163.RequestMessagePageModel>(
        () => _i163.RequestMessagePageModel(
              gh<_i67.GetRequestMessagesToUserUsecase>(),
              gh<_i108.AcceptRequestMessagesUsecase>(),
              gh<_i55.DenyRequestMessagesUsecase>(),
              gh<_i21.NavigationService>(),
            ));
    gh.factory<_i164.SavePostModel>(
        () => _i164.SavePostModel(gh<_i140.GetPetsOfUserUsecase>()));
    gh.factory<_i165.SearchWidgetModel>(() => _i165.SearchWidgetModel(
          gh<_i88.SearchPetUsecase>(),
          gh<_i89.SearchServiceUsecase>(),
          gh<_i135.FollowPetUsecase>(),
          gh<_i90.SearchUserUsecase>(),
        ));
    gh.factory<_i166.SendCommentWidgetModel>(() => _i166.SendCommentWidgetModel(
          gh<_i136.GetAllUserInPostUsecase>(),
          gh<_i119.CreateCommentUsecase>(),
          gh<_i7.EventBus>(),
          gh<_i35.LoggedInUser>(),
          gh<_i22.PlaySoundAddNewComment>(),
        ));
    gh.factory<_i167.SettingMessagePageModel>(
        () => _i167.SettingMessagePageModel(
              gh<_i103.UpdateSettingUsecase>(),
              gh<_i123.CreateSettingUsecase>(),
              gh<_i150.GetSettingUsecase>(),
              gh<_i35.LoggedInUser>(),
            ));
    gh.factory<_i168.UserProfileModel>(() => _i168.UserProfileModel(
          gh<_i151.GetUseProfileUseacse>(),
          gh<_i141.GetPostOfUserUsecase>(),
          gh<_i75.LogoutUsecase>(),
          gh<_i135.FollowPetUsecase>(),
          gh<_i131.DeletePostUsecase>(),
          gh<_i27.ToastService>(),
          gh<_i161.PostService>(),
          gh<_i7.EventBus>(),
          gh<_i35.LoggedInUser>(),
          gh<_i85.RequestContactUsecase>(),
          gh<_i97.UpdateContentRequestMessagesUsecase>(),
        ));
    gh.factory<_i169.VaccinatedWidgetModel>(() => _i169.VaccinatedWidgetModel(
          gh<_i152.GetVaccinatesUsecase>(),
          gh<_i110.AddVaccinatedUsecase>(),
          gh<_i27.ToastService>(),
          gh<_i5.DialogService>(),
          gh<_i128.DeletePetVaccinatedUsecase>(),
          gh<_i100.UpdatePetVaccinatedUsecase>(),
        ));
    gh.factory<_i170.WeightWidgetModel>(() => _i170.WeightWidgetModel(
          gh<_i111.AddWeightUsecase>(),
          gh<_i153.GetWeightsUsecase>(),
          gh<_i5.DialogService>(),
          gh<_i129.DeletePetWeightUsecase>(),
          gh<_i101.UpdatePetWeightUsecase>(),
          gh<_i27.ToastService>(),
        ));
    gh.factory<_i171.WormFlushedWidgetModel>(() => _i171.WormFlushedWidgetModel(
          gh<_i154.GetWormFlushesUsecase>(),
          gh<_i112.AddWormFlushedUsecase>(),
          gh<_i27.ToastService>(),
          gh<_i130.DeletePetWormFlushUsecase>(),
          gh<_i102.UpdatePetWormFlushUsecase>(),
          gh<_i5.DialogService>(),
        ));
    gh.factory<_i172.AddPetWidgetModel>(() => _i172.AddPetWidgetModel(
          gh<_i62.GetPetTypesUsecase>(),
          gh<_i61.GetPetBreedUsecase>(),
          gh<_i50.AddPetUsecase>(),
          gh<_i27.ToastService>(),
          gh<_i106.UploadMediaUsecase>(),
          gh<_i145.GetPresignedAvatarPetUrlUsecase>(),
        ));
    gh.factory<_i173.AdoptionPetDetailWidgetModel>(
        () => _i173.AdoptionPetDetailWidgetModel(
              gh<_i58.GetDetailPostUsecase>(),
              gh<_i161.PostService>(),
              gh<_i70.HadFoundPetUsecase>(),
            ));
    gh.factory<_i174.ChatManagerModel>(() => _i174.ChatManagerModel(
          gh<_i57.GetChatRoomsUseCase>(),
          gh<_i69.GetUserWithUuidUsecase>(),
          gh<_i54.CountUserRequestMessagesUsecase>(),
          gh<_i150.GetSettingUsecase>(),
        ));
    gh.factory<_i175.CommentServiceModel>(() => _i175.CommentServiceModel(
          gh<_i124.DeleteCommentUsecase>(),
          gh<_i82.ReportCommentUsecase>(),
          gh<_i156.LikeCommentUsecase>(),
          gh<_i132.EditCommentUsecase>(),
          gh<_i119.CreateCommentUsecase>(),
          gh<_i7.EventBus>(),
          gh<_i96.SubscriptionCommentUsecase>(),
          gh<_i24.PlaySoundReceiverComment>(),
        ));
    gh.factory<_i176.ConfirmGivePetModel>(() => _i176.ConfirmGivePetModel(
          gh<_i35.LoggedInUser>(),
          gh<_i151.GetUseProfileUseacse>(),
          gh<_i59.GetFunctionalPostReactions>(),
          gh<_i115.ChangePetOwnerUsecase>(),
          gh<_i117.ClosePostUsecase>(),
        ));
    gh.factory<_i177.EditPetProfileWidgetModel>(
        () => _i177.EditPetProfileWidgetModel(
              gh<_i61.GetPetBreedUsecase>(),
              gh<_i27.ToastService>(),
              gh<_i145.GetPresignedAvatarPetUrlUsecase>(),
              gh<_i106.UploadMediaUsecase>(),
              gh<_i99.UpdatePetInformationUsecase>(),
            ));
    gh.factory<_i178.EditUserProfileWidgetModel>(
        () => _i178.EditUserProfileWidgetModel(
              gh<_i27.ToastService>(),
              gh<_i106.UploadMediaUsecase>(),
              gh<_i146.GetPresignedAvatarUrlUsecase>(),
              gh<_i98.UpdateLocationUsecase>(),
              gh<_i121.CreateLocationUsecase>(),
              gh<_i105.UpdateUserInformationUsecase>(),
              gh<_i35.LoggedInUser>(),
            ));
    gh.factory<_i179.MapSearcherModel>(() => _i179.MapSearcherModel(
          gh<_i161.PostService>(),
          gh<_i63.GetPostByLocationUsecase>(),
        ));
    gh.factory<_i180.NewFeedWidgetModel>(() => _i180.NewFeedWidgetModel(
          gh<_i144.GetPostsUsecase>(),
          gh<_i161.PostService>(),
          gh<_i37.NewfeedCacheStorage>(),
        ));
    gh.factory<_i181.NewPostUploaderModel>(() => _i181.NewPostUploaderModel(
          gh<_i20.MediaService>(),
          gh<_i120.CreateDraftPostUsecase>(),
          gh<_i147.GetPresignedUrlUsecase>(),
          gh<_i106.UploadMediaUsecase>(),
          gh<_i109.AddPostMediaUsecase>(),
          gh<_i162.PublishUsecase>(),
          gh<_i148.GetPublishedPostUsecase>(),
          gh<_i131.DeletePostUsecase>(),
        ));
    gh.factory<_i182.PostDetailWidgetModel>(() => _i182.PostDetailWidgetModel(
          gh<_i137.GetCommentInPostUsecase>(),
          gh<_i58.GetDetailPostUsecase>(),
          gh<_i175.CommentServiceModel>(),
          gh<_i157.LikePostUsecase>(),
        ));
    gh.factory<_i183.ServiceDetailPageModel>(
        () => _i183.ServiceDetailPageModel(gh<_i179.MapSearcherModel>()));
    gh.factory<_i184.CommentBottomSheetWidgetModel>(
        () => _i184.CommentBottomSheetWidgetModel(
              gh<_i137.GetCommentInPostUsecase>(),
              gh<_i175.CommentServiceModel>(),
            ));
    return this;
  }
}

class _$RegisterModule extends _i185.RegisterModule {}
