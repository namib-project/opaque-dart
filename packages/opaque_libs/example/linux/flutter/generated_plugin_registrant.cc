//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <opaque_libs/opaque_libs_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) opaque_libs_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpaqueLibsPlugin");
  opaque_libs_plugin_register_with_registrar(opaque_libs_registrar);
}
