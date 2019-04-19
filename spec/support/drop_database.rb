client = Mysql2::Client.new(host: 'mysql', username: 'root', password: '')
client.query('DROP DATABASE simple_mysql_partitioning_test;')
client.close
