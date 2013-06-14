require 'spec_helper'
describe 'aircontrol::params', :type => :class do
  context 'supported operatingsystem' do
    let :facts do
      {
        :operatingsystem => 'Ubuntu',
        :lsbdistcodename => 'Precise',
        :osfamily        => 'Debian',
        :architecture    => 'amd64',
      }
    end

    it { should contain_aircontrol__params }

    # There are 4 resources in this class currently
    # there should not be any more resources because it is a params class
    # The resources are class[aircontrol::params], class[main], class[settings], stage[main]
    it "Should not contain any resources" do
      subject.resources.size.should == 4
    end
  end
  context 'unsupported operatingsystem' do
    let :facts do
      {
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'Sid',
        :osfamily        => 'Debian',
        :architecture    => 'i386',
      }
    end
    it do
      expect {
        should contain_aircontrol__params
      }.to raise_error(Puppet::Error, /aircontrol is not support on Debian/)
    end
  end
  context 'unsupported version of ubuntu' do
    let :facts do
      {
        :operatingsystem => 'Ubuntu',
        :lsbdistcodename => 'Maverick',
        :osfamily        => 'Debian',
        :architecture    => 'amd64',
      }
    end
    it do
      expect {
        should contain_aircontrol__params
      }.to raise_error(Puppet::Error, /aircontrol is not supported on Ubuntu Maverick/)
    end
  end
end
