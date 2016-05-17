cookbookfile "/tmp/iptables" do
  source "iptables"
end

cookbookfile "#{node[:scripts][:path]}/iptables-rules" do
  source 'iptables-rules'
  action :create
end

template "/etc/systemd/system/iprules.service" do
  source 'iprules.service.erb'
  action :create
end

['iptables', 'iprules'].each do |srvc|
  service srvc do
    action [:enable, :start]
  end
end