pkgs = ['httpd', 'mod_ssl']

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template '/etc/httpd/conf.d/ssl.conf' do
  source 'ssl.conf.erb'
  variables :params => {
    :port => node[:ui][:port]
  }
end

template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
  variables :params => {
    :port => node[:ui][:port]
  }
end

service 'httpd' do
  action [:enable, :start]
end