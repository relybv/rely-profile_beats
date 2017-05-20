# == Class: profile_beats
#
# Full description of class profile_beats here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class profile_beats
(
  $monitor_address = $::profile_beats::params::monitor_address,
) inherits ::profile_beats::params {

  if $monitor_address != undef {
    validate_string($monitor_address)
  }

  class { '::profile_beats::install': }
  -> class { '::profile_beats::config': }
  ~> class { '::profile_beats::service': }
  -> Class['::profile_beats']
}
