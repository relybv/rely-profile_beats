# == Class profile_beats::config
#
# This class is called from profile_beats for service config.
#
class profile_beats::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
