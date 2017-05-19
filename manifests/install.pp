# == Class profile_beats::install
#
# This class is called from profile_beats for install.
#
class profile_beats::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  Apt::Pin <| |> -> Package <| |>
  Apt::Source <| |> -> Package <| |>
  class { 'filebeats':
    prospectors => [{
      'input_type' => 'log',
      'doc_type'   => 'log',
      'paths'      => ['/var/log/auth.log']
                                  },
                                  { 'input_type' => 'log',
                                    'doc_type'   => 'apache',
                                    'paths'      => ['/var/log/apache2/access.log', '/var/log/apache2/error.log'],
                                    'fields'     => {'level' => 'debug', 'review' => 1}
                                  }
                                ],
    # elasticsearch_proxy_host => 'elasticsearchproxy.myserver.com',
  }

}
