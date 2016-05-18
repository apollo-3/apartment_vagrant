pkgs = ['postfix', 'dovecot']
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

include_recipe 'apache::cert_for_postfix'

template "/etc/postfix/main.cf" do
  source 'main.cf.erb'
  variables :params => {
    :hostname => node[:server][:hostname],
    :ip => node[:server][:ip]    
  }
  action :create
end

template "/etc/dovecot/conf.d/10-ssl.conf" do
  source '10-ssl.conf.erb' 
  variables :params => {
    :hostname => node[:server][:hostname]
  }
  action :create
end

cookbook_file '/etc/dovecot/dovecot.conf' do
  source 'dovecot.conf'
  action :create
end

files = ['10-auth.conf', '10-mail.conf', '10-master.conf', '10-logging.conf']
files.each do |file|
  cookbook_file "/etc/dovecot/conf.d/#{file}" do
    source file
    action :create
  end
end

cookbook_file '/etc/postfix/master.cf' do
  source 'master.cf'
  action :create
end

include_recipe 'env::add_users'

pkgs.each do |pkg|
  service pkg do
    action [:enable, :restart]
  end
end
