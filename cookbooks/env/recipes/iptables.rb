cookbook_file "#{node[:scripts][:path]}/iptables-rules" do
  source 'iptables-rules'
  action :create
end

template "/etc/systemd/system/iprules.service" do
  source 'iprules.service.erb'
  action :create
  variables :params => {
    :path => "#{node[:scripts][:path]}/iptables-rules"
  }
end

['iptables', 'iprules'].each do |srvc|
  service srvc do
    action [:enable, :start]
  end
end