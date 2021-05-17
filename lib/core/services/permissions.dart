import 'package:flutter/material.dart';
import 'package:meowoof/core/services/toast_service.dart';

class PermissionsService {
  final ToastService _toastService;

  PermissionsService(this._toastService);

  Future<bool> requestStoragePermissions({required BuildContext context}) async {
    return _requestPermissionWithErrorMessage(permission: null, errorMessage: 'Permissions denied!', context: context);
  }

  Future<bool> requestCameraPermissions({required BuildContext context}) async {
    return _requestPermissionWithErrorMessage(permission: null, errorMessage: 'Permissions denied!', context: context);
  }

  Future<bool> _requestPermissionWithErrorMessage({required dynamic permission, required String errorMessage, required BuildContext context}) async {
    return true;
  }
}
