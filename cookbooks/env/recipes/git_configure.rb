bash 'git configuration' do
  code <<-EOH
    git config --global user.email "#{node[:git][:email]}"
    git config --global user.name "#{node[:git][:name]}"
    EOH
  not_if { IO.popen('git config --global -l | grep -c user.email').read.chomp != '0'  }
end