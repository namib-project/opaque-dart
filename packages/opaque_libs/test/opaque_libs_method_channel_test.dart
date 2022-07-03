import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opaque_libs/opaque_libs_method_channel.dart';

void main() {
  MethodChannelOpaqueLibs platform = MethodChannelOpaqueLibs();
  const MethodChannel channel = MethodChannel('opaque_libs');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
