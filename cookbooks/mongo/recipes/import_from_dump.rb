cookbook_file '/tmp/dump.zip' do
  source 'dump.zip'
  action :create
end

bash 'unzip_dump' do
  cwd '/tmp'
  code <<-EOH 
    unzip dump.zip
    EOH
  only_if { !File.directory?('/tmp/dump') }
  notifies :run, "bash[restore_dump]", :immediately
end

bash 'restore_dump' do
  cwd '/tmp/dump'
  code <<-EOH
    mongorestore --db apartments apartments
    EOH
  not_if { IO.popen("[ `mongo apartments --eval 'db.users.find({}).count()' | tail -n 1` -gt 0 ] && echo -n 0 || echo -n 1").read == '0' }
  action :nothing  
end