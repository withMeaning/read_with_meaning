import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:read_with_meaning/public/features/boot_up/login/data/secure_login/storage.dart';
import 'package:read_with_meaning/public/common_widgets/errors/snack_bar.dart';

import '../auth.dart';

Future<bool> logIn(
  BuildContext context,
  String privateKey,
  bool mounted,
) async {
  try {
    Logger().e("Login with private key: $privateKey");
    var authStatus = await getAuthStatus(privateKey);
    if (authStatus.statusCode == 200) {
      await secureStorage.write(key: 'authStatus', value: "loggedIn");
      await secureStorage.write(key: 'authToken', value: privateKey);
      if (!mounted) return false;
      return true;
    } else if (authStatus.statusCode == 401) {
      if (!mounted) return false;
      snackBar(context, 'Invalid authentication.');
      await secureStorage.write(key: 'authStatus', value: "loggedOut");
    } else {
      if (!mounted) return false;
      Logger().e(authStatus.body);
      snackBar(context, 'Something went wrong.');
      await secureStorage.write(key: 'authStatus', value: "loggedOut");
    }
  } catch (e) {
    Logger().e(e);
    if (e is SocketException) {
      snackBar(context, '');
    } else if (e is TimeoutException) {
      snackBar(context, 'Connection timed out.');
    } else {
      snackBar(context, e.toString());
    }
    return false;
  }
  return false;
}

Future<void> logOut() async {
  return await secureStorage.write(key: 'authStatus', value: "loggedOut");
}

Future<bool> checkUserAuthorizationStatus(mounted) async {
  String? authStatus = await secureStorage.read(key: 'authStatus');
  if (!mounted) return false;
  if (authStatus != null && authStatus == 'loggedIn') {
    return true;
  } else {
    return false;
  }
}
