users = node[:server][:users]
users.each do |user|
  bash "add_user_#{user}" do
    code <<-EOH
      useradd #{user}
    EOH
    only_if { !system("grep #{user} /etc/passwd") }
  end
end