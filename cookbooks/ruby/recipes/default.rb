pkgs = ['ruby', 'ruby-devel', 'rubygem-bundler', 'ImageMagick-devel']
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

directory "#{node[:api][:home]}" do
  action :create
end

git "#{node[:api][:home]}" do
  repository 'https://github.com/apollo-3/apartment_api.git'
  revision 'master'
  action :sync
end

bash 'bundler install' do
  cwd "#{node[:api][:home]}"
  code <<-EOH
    /bin/bundler install
    EOH
  not_if { system("gem list | grep mongo") }
end

template '/etc/systemd/system/api.service' do
  source 'api.service.erb'
  variables :params => {
    :port => node[:api][:port]
  }
  action :create
end

service 'api' do
  action [:enable, :start]
end