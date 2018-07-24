client = Mysql2::Client.new(:host => '127.0.0.1', :username=>"root", :password=> "")
client.query("DROP DATABASE simple_mysql_partitioning_test;")
client.close