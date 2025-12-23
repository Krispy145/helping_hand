import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:utils/utils.dart';

/// A wrapper around [FlutterSecureStorage] that logs write operations.
class LoggingSecureStorage extends FlutterSecureStorage {
  const LoggingSecureStorage({super.iOptions, super.aOptions, super.lOptions, super.wOptions, super.mOptions, super.webOptions});

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) {
    AppLogger.info('Secure writing key: $key', feature: LogFeature.storage);
    return super.write(key: key, value: value, aOptions: aOptions, iOptions: iOptions, lOptions: lOptions, mOptions: mOptions, wOptions: wOptions, webOptions: webOptions);
  }

  @override
  Future<void> delete({required String key, AndroidOptions? aOptions, AppleOptions? iOptions, LinuxOptions? lOptions, AppleOptions? mOptions, WindowsOptions? wOptions, WebOptions? webOptions}) {
    AppLogger.info('Secure deleting key: $key', feature: LogFeature.storage);
    return super.delete(key: key, aOptions: aOptions, iOptions: iOptions, lOptions: lOptions, mOptions: mOptions, wOptions: wOptions, webOptions: webOptions);
  }

  @override
  Future<void> deleteAll({AndroidOptions? aOptions, AppleOptions? iOptions, LinuxOptions? lOptions, AppleOptions? mOptions, WindowsOptions? wOptions, WebOptions? webOptions}) {
    AppLogger.info('Secure deleting ALL keys', feature: LogFeature.storage);
    return super.deleteAll(aOptions: aOptions, iOptions: iOptions, lOptions: lOptions, mOptions: mOptions, wOptions: wOptions, webOptions: webOptions);
  }
}
