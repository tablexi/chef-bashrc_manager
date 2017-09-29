name 'bashrc_manager'
maintainer 'TableXI'
maintainer_email 'sysadmins@tablexi.com'
license 'MIT'
description 'Installs/Configures .bashrc file/s'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'
issues_url 'https://github.com/tablexi/chef-bashrc_manager/issues'
source_url 'https://github.com/tablexi/chef-bashrc_manager'

chef_version '~> 12'

# Operating systems supported
%w[centos redhat amazon ubuntu].each do |os|
  supports os
end
