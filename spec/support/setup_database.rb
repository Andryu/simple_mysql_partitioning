require 'active_record'
require 'erb'

host = ENV['MYSQL_DB_HOST'] || '127.0.0.1'
client = Mysql2::Client.new(host: host, username: 'root', password: '')
client.query('DROP DATABASE IF EXISTS simple_mysql_partitioning_test;')
client.query('CREATE DATABASE simple_mysql_partitioning_test;')
client.close

configurations = YAML.safe_load(ERB.new(File.read('spec/dummy/database.yml')).result, aliases: true)
config = configurations.fetch('test').dup
config['host'] = host

ActiveRecord::Base.establish_connection(config)
ActiveRecord::Schema.verbose = false

ActiveRecord::Schema[7.1].define(version: 202_401_010_000_00) do
  create_table(:daily_reports, id: false, primary_key: %i[id day]) do |t|
    t.integer :id
    t.date :day
    t.text :imp
  end
end
