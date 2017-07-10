# == Class profile_beats::config
#
# This class is called from profile_beats for service config.
#
class profile_beats::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # default prospectors
  filebeat::prospector { 'syslogs':
    paths    => [
      '/var/log/auth.log',
      '/var/log/syslog',
    ],
    doc_type => 'log',
    fields   => {
      'prospector' => 'syslogs',
    },
  }

  # optional prospecters
  if defined(Class['role_appl']) {
    filebeat::prospector { 'appachelogs':
      paths    => [
        '/var/log/apache2/*access.log',
      ],
      doc_type => 'log',
      fields   => {
        'prospector' => 'appachelogs',
      },
    }
  }
}
