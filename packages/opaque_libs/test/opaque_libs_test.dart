import 'package:flutter_test/flutter_test.dart';
import 'package:opaque_libs/opaque_libs.dart';
import 'package:opaque_libs/opaque_libs_platform_interface.dart';
import 'package:opaque_libs/opaque_libs_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOpaqueLibsPlatform 
    with MockPlatformInterfaceMixin
    implements OpaqueLibsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OpaqueLibsPlatform initialPlatform = OpaqueLibsPlatform.instance;

  test('$MethodChannelOpaqueLibs is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOpaqueLibs>());
  });

  test('getPlatformVersion', () async {
    OpaqueLibs opaqueLibsPlugin = OpaqueLibs();
    MockOpaqueLibsPlatform fakePlatform = MockOpaqueLibsPlatform();
    OpaqueLibsPlatform.instance = fakePlatform;
  
    expect(await opaqueLibsPlugin.getPlatformVersion(), '42');
  });
}
