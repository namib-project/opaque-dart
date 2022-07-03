#include "include/opaque_libs/opaque_libs_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "opaque_libs_plugin.h"

void OpaqueLibsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  opaque_libs::OpaqueLibsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
