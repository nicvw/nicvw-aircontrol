# == Class: aircontrol::params
#
# Default configuration values for the aircontrol class
#
class aircontrol::params {
  # resources

  $site      = 'http://www.ubnt.com/downloads'
  $version   = '1'
  $installer = 'aircontrol_1.4.2-beta_all.deb'
  $java      = 'jre'

  case $::operatingsystem {
    ubuntu: {

      case $::lsbdistcodename {
        lucid: {
          $jre_path = "/usr/lib/jvm/java-6-openjdk-${::architecture}/jre"
        }

        precise, quantal, raring: {
          $jre_path = "/usr/lib/jvm/java-7-openjdk-${::architecture}/jre"
        }

        default: {
          fail("${module_name} is not supported on ${::operatingsystem} ${::lsbdistcodename}")
        }
      }

      $package_cache     = '/var/cache/apt/archives'
      $packages_version1 = [ 'jsvc' ]
      $packages_version2 = [ 'jsvc', 'iperf', 'traceroute' ]
      $pidfile           = '/var/run/aircontrol.pid'
    }

    default: {
      fail ("${module_name} is not support on ${::operatingsystem}")
    }
  }
}
