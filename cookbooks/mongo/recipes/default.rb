pkgs = ['mongodb-server', 'mongodb']
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service 'mongod' do
  action [:enable, :start]
end

cookbook_file '/tmp/users.js' do
  source 'users.js'
  action :create
end

bash 'import mongo dump' do
  cwd '/tmp'
  code <<-EOH
    /bin/mongo < users.js
    EOH
  not_if { IO.popen("[ `mongo apartments --eval 'db.users.find({}).count()' | tail -n 1` -gt 0 ] && echo -n 0 || echo -n 1").read == '0' }
end