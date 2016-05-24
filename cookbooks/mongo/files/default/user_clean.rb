require 'mongo'
require 'date'

# Dumping Mongo logger
Mongo::Logger.logger = ::Logger.new('/dev/null')
# DB connection
client = Mongo::Client.new(['127.0.0.1'], :database => 'apartments')
passed_time = DateTime.now.prev_day(7)
users = client[:users].find({:verified => false, :creation_date => {'$lt' => passed_time}})
users.each do |user|
  client[:users].delete_one user
  puts "#{Time.now} - #{user[:mail]} was removed"
end
client.close
