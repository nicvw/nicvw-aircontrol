require 'spec_helper'

describe 'aircontrol', :type => :class do

  context 'when deploying on ubuntu' do
    let :facts do
      {
        :operatingsystem => 'Ubuntu',
        :lsbdistcodename => 'precise',
        :osfamily        => 'Debian',
        :architecture    => 'amd64',
      }
    end

    it { should contain_class('java') }
    it { should have_class_count(2) }
    it { should have_package_resource_count(1) }
    it { should contain_package('jsvc').with({
      'before' => 'Exec[install aircontrol]',
    }) }

  end
end
