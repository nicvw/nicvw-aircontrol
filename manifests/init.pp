# == Class: aircontrol
#
# Manages the Ubiquiti airControl software on Ubuntu hosts.  If run without any
# parameters it will install the current defacto stable release, 1.4.2
#
# === Parameters
#
# [*installer*]
#   The filename that will be downloaded and installed.
#   Default: aircontrol_1.4.2-beta_all.deb
#
# [*version*]
#   The version of airControl that will be installed.
#   Default: 1
#
# === Examples
#
#  class { 'example_class': }
#
# === Authors
#
# Nicholas von Waltsleben <nic@cloudseed.co.za>
#
# === Copyright
#
# Copyright 2013 Nicholas von Waltsleben.
#
class aircontrol(
  $installer = $aircontrol::params::installer,
  $version   = $aircontrol::params::version,
) inherits aircontrol::params {

  include java

  $jre_path      = $aircontrol::params::jre_path
  $package_cache = $aircontrol::params::package_cache
  $site          = $aircontrol::params::site

  case $version {
    '1': {
      $packages     = $aircontrol::params::packages_version1
      $version_real = ''
      $hasstatus    = false
    }

    '2': {
      $packages     = $aircontrol::params::packages_version2
      $version_real = $version
      $hasstatus    = true
    }

    default: {
      fail('Invalid value for $version, must be "1" or "2"')
    }
  }

  ensure_resource('package', $packages, { tag => 'aircontrol::prereq'})

  Package <| tag == 'aircontrol::prereq' |> {
    before +> Exec['install aircontrol']
  }

  Exec { path => ['/usr/sbin', '/sbin', '/usr/bin', '/bin'] }

  exec { 'wget aircontrol':
    command => "wget ${site}/aircontrol${version_real}/${installer} -O ${package_cache}/${installer}",
    unless  => "dpkg-deb -I ${package_cache}/${installer} > /dev/null 2>&1",
    before  => Exec['install aircontrol'],
  }

  exec { 'install aircontrol':
    command => "dpkg -i ${package_cache}/${installer}",
    unless  => "dpkg -l aircontrol${version_real}",
    before  => File_line['aircontrol JAVA_HOME'],
  }

  file_line { 'aircontrol JAVA_HOME':
    match  => '^JAVA_HOME=',
    line   => "JAVA_HOME=${jre_path}",
    path   => "/etc/init.d/aircontrol${version_real}",
    before => Service['aircontrol'],
  }

  service { 'aircontrol':
    enable     => true,
    ensure     => running,
    hasrestart => true,
    hasstatus  => $hasstatus,
    name       => "aircontrol${version_real}",
  }

  # Setup dependency on the puppetlabs-java module
  Class['java'] -> Class['aircontrol']

}
