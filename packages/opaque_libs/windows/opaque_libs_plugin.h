#ifndef FLUTTER_PLUGIN_OPAQUE_LIBS_PLUGIN_H_
#define FLUTTER_PLUGIN_OPAQUE_LIBS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace opaque_libs {

class OpaqueLibsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  OpaqueLibsPlugin();

  virtual ~OpaqueLibsPlugin();

  // Disallow copy and assign.
  OpaqueLibsPlugin(const OpaqueLibsPlugin&) = delete;
  OpaqueLibsPlugin& operator=(const OpaqueLibsPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace opaque_libs

#endif  // FLUTTER_PLUGIN_OPAQUE_LIBS_PLUGIN_H_
