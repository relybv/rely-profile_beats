# == Class profile_beats::params
#
# This class is meant to be called from profile_beats.
# It sets variables according to platform.
#
class profile_beats::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'profile_beats'
      $service_name = 'profile_beats'
    }
    'RedHat', 'Amazon': {
      $package_name = 'profile_beats'
      $service_name = 'profile_beats'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
