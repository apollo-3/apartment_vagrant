directory "/etc/httpd/certs" do
  action :create
end

fls = ["#{node[:server][:hostname]}.key", "#{node[:server][:hostname]}.crt", "intermediate.crt"]
fls.each do |file|  
  cookbook_file "/etc/httpd/certs/#{file}" do
    source file
    action :create
    notifies :run, "bash[generate_postfix_certificate]", :delayed    
  end
end

bash 'generate_postfix_certificate' do
  cwd '/etc/httpd/certs'
  code <<-EOH
    cat "#{node[:server][:hostname]}.crt" intermediate.crt > ./postfix.crt
  EOH
  action :nothing
end