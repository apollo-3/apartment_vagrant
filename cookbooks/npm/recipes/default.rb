package 'npm' do
  action :install
end

directory "#{node[:ui][:home]}" do
  action :create
end

git "#{node[:ui][:home]}" do
  repository 'https://github.com/apollo-3/apartment_ui.git'
  revision 'master'
  action :sync
end

bash 'install npm tools' do
  code <<-EOH
    npm install -g grunt-cli bower nodemon node-sass 
    EOH
  not_if {system('grunt --help')}
end

bash 'install npm dependencies' do
  cwd "#{node[:ui][:home]}"
  code <<-EOH
    npm install
    EOH
  not_if {::File.directory?("#{node[:ui][:home]}/node_modules")}
end

bash 'install bower components' do
  cwd "#{node[:ui][:home]}"
  code <<-EOH
    bower install --allow-root
    EOH
  not_if {::File.directory?("#{node[:ui][:home]}/bower_components")}
end

srvcs = ['ui', 'scss']
srvcs.each do |srvc|
  template "/etc/systemd/system/#{srvc}.service" do
    source "#{srvc}.service.erb"
    variables :params => {
      :home => node[:ui][:home]
    }
  end
  service "#{srvc}" do
    action [:enable, :start]
  end
end