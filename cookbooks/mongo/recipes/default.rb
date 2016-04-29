pkgs = ['mongodb-server', 'mongodb']
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

service 'mongod' do
  action [:enable, :start]
end

include_recipe "mongo::import_from_dump"