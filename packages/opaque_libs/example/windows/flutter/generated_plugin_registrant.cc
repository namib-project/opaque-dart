//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <opaque_libs/opaque_libs_plugin_c_api.h>
#include <sodium_libs/sodium_libs_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  OpaqueLibsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("OpaqueLibsPluginCApi"));
  SodiumLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SodiumLibsPlugin"));
}
