import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:utils/utils.dart';

typedef DevicePushTokenReader = Future<String?> Function();

/// Initializes FCM when native Firebase config is present.
/// Local/CI builds without `google-services.json` skip this and send no token.
Future<DevicePushTokenReader?> firebasePushTokenReader() async {
  try {
    await Firebase.initializeApp();
  } catch (error) {
    AppLogger.info('FCM skipped until Firebase config files are added', extras: {'error': error.toString()});
    return null;
  }

  try {
    await FirebaseMessaging.instance.requestPermission();
  } catch (error) {
    AppLogger.info('Notification permission was not granted', extras: {'error': error.toString()});
  }

  return () async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (error, stack) {
      AppLogger.error('Could not read FCM token', error: error, stackTrace: stack);
      return null;
    }
  };
}
