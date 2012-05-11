# Global values that must be set

group { 'puppet': ensure => 'present' }


exec {'apt-get-update':

  command => '/usr/bin/apt-get update',

}
Exec["apt-get-update"] -> Package <| |>


exec {'apt-get-update-refresh':

  command => '/usr/bin/apt-get update',

  refreshonly => true,

}
 

define ppa($team, $ppa) {

  exec {"add-ppa-$name":

    command => "add-apt-repository ppa:$team/$ppa",

    path => ['/usr/bin'],

    creates => "/etc/apt/sources.list.d/$team-$ppa-$lsbdistcodename.list",

    require => Package['python-software-properties'],

    notify => Exec['apt-get-update-refresh'],

  }
 
  package {'python-software-properties': 

    ensure => installed,

    require => Exec['apt-get-update'],

  }

}
 

ppa {'java6':

  team => 'sun-java-community-team',

  ppa => 'sun-java6',

}
 

file {'java-seeds':

  path => "/tmp/sun-java-licence.seeds",

  content => 'sun-java6-bin shared/accepted-sun-dlj-v1-1 boolean true

sun-java6-jdk shared/accepted-sun-dlj-v1-1 boolean true

sun-java6-jre shared/accepted-sun-dlj-v1-1 boolean true'

}
 

package {'sun-java6-jdk':

  ensure => installed,

  responsefile => "/tmp/sun-java-licence.seeds",

  require => [Ppa['java6'], File['java-seeds']],

}


