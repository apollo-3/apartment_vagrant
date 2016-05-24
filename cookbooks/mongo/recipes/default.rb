pkgs = ['mongodb-server', 'mongodb']
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service 'mongod' do
  action [:enable, :start]
end

fls = ['user_clean.rb', 'del_user.rb']
fls.each do |file|
  cookbook_file "#{node[:scripts][:path]}/#{file}" do
    source file
    mode '751'
    action :create
  end
end

template "/etc/cron.d/user_clean" do
  source "user_clean.erb"
  variables :params => {
    :path => "#{node[:scripts][:path]}/user_clean.rb",
    :log => "#{node[:scripts][:path]}/logs/user_clean.log"
  }
  action :create
end