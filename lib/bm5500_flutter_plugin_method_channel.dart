import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bm5500_flutter_plugin_platform_interface.dart';

/// An implementation of [Bm5500FlutterPluginPlatform] that uses method channels.
class MethodChannelBm5500FlutterPlugin extends Bm5500FlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bm5500_flutter_plugin');

  @override
  Future<String?> openDevice() async {
    final version = await methodChannel.invokeMethod<String>('openDevice');
    return version;
  }

  @override
  Future<String?> closeDevice() async {
    return await methodChannel.invokeMethod<String>('closeDevice');
  }

  @override
  Future<String?> captureFingerprint() async {
    return await methodChannel.invokeMethod<String>('captureFingerprint');
  }
}
