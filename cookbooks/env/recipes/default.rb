cookbook_file '/etc/yum.repos.d/epel.repo' do
  source 'epel.repo'
end

pkgs = ['net-tools']
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service 'firewalld' do
  action [:disable, :stop]
end