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

  class { 'filebeat':
    manage_repo => false,
    outputs     => {
      'elasticsearch' => {
      'hosts' => [
        "http://${profile_beats::monitor_address}:9200",
      ],
      },
    },
  }

  filebeat::prospector { 'syslogs':
    paths    => [
      '/var/log/auth.log',
      '/var/log/syslog',
    ],
    doc_type => 'log',
  }

}
