//
//  Generated file. Do not edit.
//

#include "generated_plugin_registrant.h"

#include <open_file/open_file_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) open_file_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpenFilePlugin");
  open_file_plugin_register_with_registrar(open_file_registrar);
}
