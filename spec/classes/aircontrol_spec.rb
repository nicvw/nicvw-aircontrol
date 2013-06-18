require 'spec_helper'
describe 'aircontrol', :type => :class do
  context 'when deploying version 1 on ubuntu 12.04 amd64' do
    let :facts do
      {
        :operatingsystem => 'Ubuntu',
        :lsbdistcodename => 'Precise',
        :osfamily        => 'Debian',
        :architecture    => 'amd64',
      }
    end
    it do
      should contain_class('java')
    end
    it do
      should contain_package('jsvc').with({
        'before' => 'Exec[install aircontrol]',
      })
    end
    it do
      should contain_exec('wget aircontrol').with({
        'command' => 'wget http://www.ubnt.com/downloads/aircontrol/aircontrol_1.4.2-beta_all.deb -O /var/cache/apt/archives/aircontrol_1.4.2-beta_all.deb',
        'unless'  => 'dpkg-deb -I /var/cache/apt/archives/aircontrol_1.4.2-beta_all.deb > /dev/null 2>&1',
        'before'  => 'Exec[install aircontrol]',
      })
    end
    it do
      should contain_exec('install aircontrol').with({
        'command' => 'dpkg -i /var/cache/apt/archives/aircontrol_1.4.2-beta_all.deb',
        'unless'  => 'dpkg -l aircontrol',
        'before'  => 'File_line[aircontrol JAVA_HOME]',
      })
    end
    it do
      should contain_file_line('aircontrol JAVA_HOME').with({
        'match'  => '^JAVA_HOME=',
        'line'   => 'JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre',
        'path'   => '/etc/init.d/aircontrol',
        'before' => 'Service[aircontrol]',
      })
    end
    it do
      should contain_service('aircontrol').with({
        'enable'     => true,
        'ensure'     => 'running',
        'hasrestart' => true,
        'hasstatus'  => false,
        'name'       => 'aircontrol',
        'status'     => '/usr/bin/test -f /var/run/aircontrol.pid && /bin/ps `cat /var/run/aircontrol.pid`'
      })
    end
  end
  context 'when deploying version 2 beta on ubuntu 10.04 i386' do
    let :facts do
      {
      :operatingsystem => 'Ubuntu',
      :lsbdistcodename => 'Lucid',
      :osfamily        => 'Debian',
      :architecture    => 'i386',
      }
    end
    let :params do
      {
        :version => '2',
        :installer => 'beta_installer.deb',
      }
    end
    it { should contain_class('java') }
    it do
      should contain_package('jsvc').with({
        'before' => 'Exec[install aircontrol]',
      })
    end
    it do
      should contain_package('iperf').with({
        'before' => 'Exec[install aircontrol]',
      })
    end
    it do
      should contain_package('traceroute').with({
        'before' => 'Exec[install aircontrol]',
      })
    end
    it do
      should contain_exec('wget aircontrol').with({
        'command' => 'wget http://www.ubnt.com/downloads/aircontrol2/beta_installer.deb -O /var/cache/apt/archives/beta_installer.deb',
        'unless'  => 'dpkg-deb -I /var/cache/apt/archives/beta_installer.deb > /dev/null 2>&1',
        'before'  => 'Exec[install aircontrol]',
      })
    end
    it do
      should contain_exec('install aircontrol').with({
        'command' => 'dpkg -i /var/cache/apt/archives/beta_installer.deb',
        'unless'  => 'dpkg -l aircontrol2',
        'before'  => 'File_line[aircontrol JAVA_HOME]',
      })
    end
    it do
      should contain_file_line('aircontrol JAVA_HOME').with({
        'match'  => '^JAVA_HOME=',
        'line'   => 'JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386/jre',
        'path'   => '/etc/init.d/aircontrol2',
        'before' => 'Service[aircontrol]',
      })
    end
    it do
      should contain_service('aircontrol').with({
        'enable'     => true,
        'ensure'     => 'running',
        'hasrestart' => true,
        'hasstatus'  => true,
        'name'       => 'aircontrol2',
      })
    end
  end
  context 'when deploying an unsupported version' do
    let :facts do
      {
      :operatingsystem => 'Ubuntu',
      :lsbdistcodename => 'Precise',
      :osfamily        => 'Debian',
      :architecture    => 'i386',
      }
    end
    let :params do
      {
        :version => '3',
        :installer => 'beta_installer.deb',
      }
    end
    it do
      expect {
        should contain_aircontrol
      }.to raise_error(Puppet::Error, /Invalid value for \$version, must be \"1\" or \"2\"/)
    end
  end
end
