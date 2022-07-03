
import 'opaque_libs_platform_interface.dart';

class OpaqueLibs {
  Future<String?> getPlatformVersion() {
    return OpaqueLibsPlatform.instance.getPlatformVersion();
  }
}
