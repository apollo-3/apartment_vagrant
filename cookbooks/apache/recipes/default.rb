pkgs = ['httpd', 'mod_ssl']

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

directory "/etc/httpd/certs" do
  action :create
end

fls = ["#{node[:server][:hostname]}.key", "#{node[:server][:certificate]}.crt", "intermediate.crt"]
fls.each do |file|  
  cookbook_file "/etc/httpd/certs/#{file}" do
    source file
    action :create
  end
end

template '/etc/httpd/conf.d/ssl.conf' do
  source 'ssl.conf.erb'
  variables :params => {
    :ui_port => node[:ui][:port],
    :api_port => node[:api][:port],
    :hostname => node[:server][:hostname],
    :certificate => node[:server][:certificate]
  }
end

excpts = []
node[:vhosts].each { |vhost| excpts.push vhost.gsub('.','\.') }

template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
  variables :params => {
    :ui_port => node[:ui][:port],
    :api_port => node[:api][:port],
    :exceptions => excpts
  }
end

directory '/etc/httpd/vhosts' do
  action :create
end

node[:vhosts].each do |vhost|
  cookbook_file "/etc/httpd/vhosts/#{vhost}.conf" do
    source vhost
    action :create
  end
end

service 'httpd' do
  action [:enable, :start]
end