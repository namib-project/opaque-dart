import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'opaque_libs_method_channel.dart';

abstract class OpaqueLibsPlatform extends PlatformInterface {
  /// Constructs a OpaqueLibsPlatform.
  OpaqueLibsPlatform() : super(token: _token);

  static final Object _token = Object();

  static OpaqueLibsPlatform _instance = MethodChannelOpaqueLibs();

  /// The default instance of [OpaqueLibsPlatform] to use.
  ///
  /// Defaults to [MethodChannelOpaqueLibs].
  static OpaqueLibsPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OpaqueLibsPlatform] when
  /// they register themselves.
  static set instance(OpaqueLibsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
