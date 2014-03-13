require 'spec_helper'

describe 'rackspace_nginx::default' do
  let(:chef_run) { ChefSpec::Runner.new(platform: 'debian', version: '7.2').converge(described_recipe) }

  it 'loads the ohai plugin' do
    expect(chef_run).to include_recipe('rackspace_nginx::ohai_plugin')
  end

  context 'configured to install by package' do
    context 'in a redhat-based platform' do
      let(:chef_run) { ChefSpec::Runner.new(platform: 'redhat', version: '6.3').converge(described_recipe) }

      it 'includes the rackspace_nginx::repo recipe if the source is nginx' do
        chef_run.node.set['rackspace_nginx']['repo_source'] = 'nginx'
        chef_run.converge(described_recipe)
        expect(chef_run).to include_recipe('rackspace_nginx::repo')
      end
    end

    it 'installs the package' do
      expect(chef_run).to install_package('nginx')
    end

    it 'installs a specific version when specified' do
      chef_run.node.set['rackspace_nginx']['package_version'] = '1.4.5'
      chef_run.converge(described_recipe)
      expect(chef_run).to install_package('nginx').with(version: '1.4.5')
    end

    it 'enables the service' do
      expect(chef_run).to enable_service('nginx')
    end

    it 'executes common nginx configuration' do
      expect(chef_run).to include_recipe('rackspace_nginx::commons')
    end
  end

  it 'starts the service' do
    expect(chef_run).to start_service('nginx')
  end
  it 'populate the /etc/nginx' do
    expect(chef_run).to create_directory('/etc/nginx')
  end
  it 'populate the /var/log/nginx' do
    expect(chef_run).to create_directory('/var/log/nginx')
  end
  it 'populate the /var/run' do
    expect(chef_run).to create_directory('/var/run')
  end

  it 'populate the /etc/nginx/sites-available' do
    expect(chef_run).to create_directory('/etc/nginx/sites-available')
  end
  it 'populate the /etc/nginx/sites-enabled' do
    expect(chef_run).to create_directory('/etc/nginx/sites-enabled')
  end
  it 'populate the /etc/nginx/conf.d' do
    expect(chef_run).to create_directory('/etc/nginx/conf.d')
  end
  it 'creates the template' do
    expect(chef_run).to create_template('nginx.conf')
  end
  it 'creates the template' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/default')
  end
  it 'creates the template' do
    expect(chef_run).to create_template('/usr/sbin/nxensite')
  end
  it 'creates the template' do
    expect(chef_run).to create_template('/usr/sbin/nxdissite')
  end
end
