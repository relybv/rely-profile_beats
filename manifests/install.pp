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

  if $::osfamily == 'Debian' {
    Class['apt::update'] -> Package['filebeat']
    ensure_resource('apt::source', 'elasticrepo', {'ensure' => 'present', 'location' => 'https://artifacts.elastic.co/packages/5.x/apt', 'release' => 'stable', 'repos' => 'main', 'key' => { 'id' => '46095ACC8548582C1A2699A9D27D666CD88E42B4', 'source' => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',} })
  }

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
