import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_with_meaning/public/features/experience/data/realm_repository.dart';

/* 
Future<bool> logIn(
  BuildContext context,
  String privateKey,
  bool mounted,
) async {
  try {
    //Logger().e("Login with private key: $privateKey");
    var authStatus = await getAuthStatus(privateKey);
    if (authStatus.statusCode == 200) {
      await secureStorage.write(key: 'authStatus', value: "loggedIn");
      await secureStorage.write(key: 'authToken', value: privateKey);
      await secureStorage.write(
          key: 'email', value: jsonDecode(authStatus.body)["auth_email"]);

      if (!mounted) return false;
      return true;
    } else if (authStatus.statusCode == 401) {
      if (!mounted) return false;
      snackBar(context, 'Invalid authentication.');
      await Sentry.captureMessage('Invalid authentication.');
      await secureStorage.write(key: 'authStatus', value: "loggedOut");
    } else {
      if (!mounted) return false;
      Logger().e(authStatus.body);
      snackBar(context, 'Something went wrong.');
      await secureStorage.write(key: 'authStatus', value: "loggedOut");
    }
  } catch (e, stackTrace) {
    await Sentry.captureException(
      e,
      stackTrace: stackTrace,
    );
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
} */

Future<void> logOut(WidgetRef ref) async {
  //ref.read(appProvider).currentUser?.logOut();
  // await secureStorage.write(key: 'authStatus', value: "loggedOut");
  //await secureStorage.write(key: 'authToken', value: "");
  ref.read(userProvider)?.logOut();
  return ref.refresh(userProvider);
}

/* Future<bool> checkUserAuthorizationStatus(mounted) async {
  String? authStatus = await secureStorage.read(key: 'authStatus');
  if (!mounted) return false;
  if (authStatus != null && authStatus == 'loggedIn') {
    return true;
  } else {
    return false;
  }
} */
