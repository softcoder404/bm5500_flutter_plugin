import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bm5500_flutter_plugin_method_channel.dart';

abstract class Bm5500FlutterPluginPlatform extends PlatformInterface {
  /// Constructs a Bm5500FlutterPluginPlatform.
  Bm5500FlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static Bm5500FlutterPluginPlatform _instance = MethodChannelBm5500FlutterPlugin();

  /// The default instance of [Bm5500FlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelBm5500FlutterPlugin].
  static Bm5500FlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Bm5500FlutterPluginPlatform] when
  /// they register themselves.
  static set instance(Bm5500FlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> openDevice() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> closeDevice() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
  Future<String?> captureFingerprint() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
