require 'spec_helper'

describe 'diamond', :type => :class do

  context 'no parameters' do
    it { should contain_package('diamond').with_ensure('present')}
    it { should create_class('diamond::config')}
    it { should create_class('diamond::install')}
    it { should create_class('diamond::service')}

    it { should contain_file('/etc/diamond/diamond.conf').with_content(/interval = 30/)}

    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.librato.LibratoHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.riemann.RiemannHandler/)}

    it { should contain_service('diamond').with_ensure('running').with_enable('true') }
  end

  context 'with a custom graphite host' do
    let(:params) { {'graphite_host' => 'graphite.example.com'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/host = graphite.example.com/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.librato.LibratoHandler/)}
  end

  context 'with a riemann host' do
    let(:params) { {'riemann_host' => 'riemann.example.com'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/host = riemann.example.com/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.riemann.RiemannHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.librato.LibratoHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
  end

  context 'with librato settings' do
    let(:params) { {'librato_user' => 'bob', 'librato_apikey' => 'jim'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.librato.LibratoHandler/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/user = bob/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/apikey = jim/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
  end

  context 'with librato and graphite settings' do
    let(:params) { {'graphite_host' => 'graphite.example.com', 'librato_user' => 'bob', 'librato_apikey' => 'jim'} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.librato.LibratoHandler/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/user = bob/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/apikey = jim/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/host = graphite.example.com/)}
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
  end

  context 'with a version' do
    let(:params) { {'version' => '1.0.0'} }
    it { should contain_package('diamond').with_ensure('1.0.0')}
  end

  context 'with a custom polling interval' do
    let(:params) { {'interval' => 10} }
    it { should contain_file('/etc/diamond/diamond.conf').with_content(/interval = 10/)}
  end

  context 'with service instructions' do
    let(:params) { {'start' => false, 'enable' => false} }
    it { should contain_service('diamond').with_ensure('stopped').with_enable('false') }
  end

  context 'with git repository' do
    it { should contain_file('/usr/bin/diamond')}
    it { should create_class('diamond::config')}
    it { should create_class('diamond::install')}
    it { should create_class('diamond::service')}

    it { should contain_file('/etc/diamond/diamond.conf').with_content(/interval = 30/)}

    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.librato.LibratoHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.graphite.GraphiteHandler/)}
    it { should_not contain_file('/etc/diamond/diamond.conf').with_content(/diamond.handler.riemann.RiemannHandler/)}

    it { should contain_service('diamond').with_ensure('running').with_enable('true') }
  end

end
