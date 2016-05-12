package "bind" do
  action :install
end

template "/etc/named.conf" do
  source "named.conf.erb"
  variables :params => {
    :hostname => node[:server][:hostname],
    :ip => node[:server][:ip].split('.')[0..2].reverse.join('.')
  }
end

template "/var/named/forward.mysite" do
  source "forward.mysite.erb"
  variables :params => {
    :hostname => node[:server][:hostname],
    :ip => node[:server][:ip]
  }
end

template "/var/named/reverse.mysite" do
  source "reverse.mysite.erb"
  variables :params => {
    :hostname => node[:server][:hostname],
    :ip => node[:server][:ip].split('.')[0..2].reverse.join('.')
  }
end

service "named" do
  action [:enable, :restart]
end