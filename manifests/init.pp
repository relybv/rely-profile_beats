# == Class: profile_beats
#
# Install elasticsearch beats. .
#
# === Parameters
#
# [*monitor_address*]
#   Address to send beats output, default 'localhost'
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
