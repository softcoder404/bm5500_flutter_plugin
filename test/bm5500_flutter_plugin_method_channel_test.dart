import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bm5500_flutter_plugin/bm5500_flutter_plugin_method_channel.dart';

void main() {
  MethodChannelBm5500FlutterPlugin platform = MethodChannelBm5500FlutterPlugin();
  const MethodChannel channel = MethodChannel('bm5500_flutter_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.init(), '42');
  });
}
