
import 'bm5500_flutter_plugin_platform_interface.dart';

class Bm5500FlutterPlugin {

  Future<String?> openDevice() {
    return Bm5500FlutterPluginPlatform.instance.openDevice();
  }

  Future<String?> closeDevice() {
    return Bm5500FlutterPluginPlatform.instance.closeDevice();
  }
  Future<String?> captureFingerprint() {
    return Bm5500FlutterPluginPlatform.instance.captureFingerprint();
  }
}
