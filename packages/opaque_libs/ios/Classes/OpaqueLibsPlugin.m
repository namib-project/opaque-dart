#import "OpaqueLibsPlugin.h"
#if __has_include(<opaque_libs/opaque_libs-Swift.h>)
#import <opaque_libs/opaque_libs-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "opaque_libs-Swift.h"
#endif

@implementation OpaqueLibsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOpaqueLibsPlugin registerWithRegistrar:registrar];
}
@end
