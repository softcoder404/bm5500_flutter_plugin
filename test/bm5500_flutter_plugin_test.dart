import 'package:flutter_test/flutter_test.dart';
import 'package:bm5500_flutter_plugin/bm5500_flutter_plugin.dart';
import 'package:bm5500_flutter_plugin/bm5500_flutter_plugin_platform_interface.dart';
import 'package:bm5500_flutter_plugin/bm5500_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBm5500FlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements Bm5500FlutterPluginPlatform {

  @override
  Future<String?> init() => Future.value('42');
}

void main() {
  final Bm5500FlutterPluginPlatform initialPlatform = Bm5500FlutterPluginPlatform.instance;

  test('$MethodChannelBm5500FlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBm5500FlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    Bm5500FlutterPlugin bm5500FlutterPlugin = Bm5500FlutterPlugin();
    MockBm5500FlutterPluginPlatform fakePlatform = MockBm5500FlutterPluginPlatform();
    Bm5500FlutterPluginPlatform.instance = fakePlatform;

    expect(await bm5500FlutterPlugin.initializePlugin(), '42');
  });
}
