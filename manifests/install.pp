# == Class profile_beats::install
#
# This class is called from profile_beats for install.
#
class profile_beats::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $profile_beats::monitor_address == undef {
    $monitor_address = localhost
  } else {
    $monitor_address = $profile_beats::monitor_address
  }
  notify {"Logging address ${profile_beats::monitor_address} ":}

  Apt::Pin <| |> -> Package <| |>
  Apt::Source <| |> -> Package <| |>
  class { 'filebeats':
    prospectors              => [
    {
      'input_type' => 'log',
      'doc_type'   => 'log',
      'paths'      => ['/var/log/auth.log']
    },
    {
      'input_type' => 'log',
      'doc_type'   => 'log',
      'paths'      => ['/var/log/syslog']
    },
    {
      'input_type' => 'log',
      'doc_type'   => 'apache',
      'paths'      => ['/var/log/apache2/access.log', '/var/log/apache2/error.log'],
      'fields'     => {'level' => 'debug', 'review' => 1}
    }
    ],
    elasticsearch_proxy_host => $profile_beats::monitor_address,
  }

}
