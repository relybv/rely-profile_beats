# == Class profile_beats::config
#
# This class is called from profile_beats for service config.
#
class profile_beats::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if defined(Class['role_monitor']) {
    exec { 'install_beats_template':
      command => '/usr/share/filebeat/scripts/import_dashboards -only-index',
      require => [ Es_Instance_Conn_Validator['es-01'], Class['filebeat']],
    }
  }

  # default prospectors
  filebeat::prospector { 'syslogs':
    paths         => [
      '/var/log/messages',
      '/var/log/syslog',
    ],
    exclude_files => ['.gz$'],
    doc_type      => 'log',
    fields        => {
      'prospector' => 'syslogs',
    },
    multiline     => {
      'pattern' => '^\\s',
      'match'   => 'after',
    },
  }

  filebeat::prospector { 'authlogs':
    paths         => [
      '/var/log/auth.log',
    ],
    exclude_files => ['.gz$'],
    doc_type      => 'log',
    fields        => {
      'prospector' => 'authlogs',
    },
    multiline     => {
      'pattern' => '^\\s',
      'match'   => 'after',
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
