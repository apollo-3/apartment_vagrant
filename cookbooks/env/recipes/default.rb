cookbook_file '/etc/yum.repos.d/epel.repo' do
  source 'epel.repo'
end

pkgs = ['net-tools', 'zip', 'unzip', 'gcc-c++']
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service 'firewalld' do
  action [:disable, :stop]
end

directory "#{node[:scripts][:path]}" do
  action :create
end

template "#{node[:scripts][:path]}/make_dump.sh" do
  source "make_dump.sh.erb"
  variables :params => {
    path => "#{node[:ui][:home]}/photos"
  }
  mode '0755'
  action :create
end