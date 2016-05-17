pkgs = ['httpd', 'mod_ssl']

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

directory "/etc/httpd/certs" do
  action :create
end

fls = ["#{node[:server][:certificate]}.key", "#{node[:server][:certificate]}.crt", "intermediate.crt"]
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
    :hostname => node[:server][:hostname]
  }
end

template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
  variables :params => {
    :ui_port => node[:ui][:port],
    :api_port => node[:api][:port]
  }
end

service 'httpd' do
  action [:enable, :start]
end