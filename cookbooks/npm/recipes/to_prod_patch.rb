bash "change_ip_in_sources" do
  code <<-EOH
    sed -i 's/192\.168\.33\.123/estate-hunt\.com/g' "#{node[:ui][:home]}/public/providers/values.js"
    sed -i 's/192\.168\.33\.123/estate-hunt\.com/g' "#{node[:api][:home]}/classes/helper.rb"    
  EOH
  only_if { ::File.exists? "#{node[:ui][:home]}/public/providers/values.js" && ::File.exists? "#{node[:api][:home]}/classes/helper.rb"}
end