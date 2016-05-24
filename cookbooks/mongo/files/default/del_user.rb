require 'mongo'

userMail = ARGV[0]
if userMail != NIL
  # Dumping Mongo logger
  Mongo::Logger.logger = ::Logger.new('/dev/null')
  # DB connection
  client = Mongo::Client.new(['127.0.0.1'], :database => 'apartments')
  client[:users].delete_one({:mail => userMail})
  prjs = client[:projects].find({:owners => userMail})

  prjs.each do |prj|
    if prj[:owners].length == 1
     client[:projects].delete_one prj
    else
      client[:projects].update_one(prj, {'$pull' => {:owners => userMail}})
    end
  end
  puts "#{Time.now} - #{userMail} was deleted"
  client.close
else
  puts "ERROR: enter user\'s mail to delete!!!"
end
