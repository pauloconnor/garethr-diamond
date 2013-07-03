class diamond::install {
  if package == true {
    package { 'diamond':
      ensure  => $diamond::version,
    }
  } else {
    vcsrepo { '/usr/local/src/diamond' :
      ensure    => present,
      provider  => git,
      source    => 'https://github.com/BrightcoveOS/Diamond.git',
      notify    => Exec['Install Diamond'],
    }

    exec { 'Install Diamond':
      cwd       => '/usr/local/src/diamond',
      command   => '/usr/bin/make install',
    }

    file { '/etc/init.d/diamond':
      ensure  => present,
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      source  => "puppet:///modules/diamond/etc/init.d/diamond",
      require => Vcsrepo['/usr/local/src/diamond'],
    }

    file { '/var/log/diamond/':
      ensure  => directory,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
    }
  }
  file { '/var/run/diamond':
    ensure => directory,
  }
}
