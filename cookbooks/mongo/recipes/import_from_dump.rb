files = ["dump.zip", "photos.zip"]
files.each do |file|
  cookbook_file "/tmp/#{file}" do
    source file
    action :create
  end
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

directory "#{node[:ui][:home]}/photos" do
  recursive true
  action :create
end

bash 'unzip_photos' do
  cwd '/tmp'
  code <<-EOH
    unzip photos.zip
    [ `ls -l /tmp/photos/ | grep root | wc -l` -gt 0 ] && mv photos/* "#{node[:ui][:home]}/photos" || echo 'nothing_to_do_no_file_in_photos'
    EOH
  only_if { !File.directory?('/tmp/photos') }
end  