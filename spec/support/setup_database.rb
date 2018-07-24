client = Mysql2::Client.new(:host => '127.0.0.1', :username=>"root", :password=> "")
client.query("CREATE DATABASE simple_mysql_partitioning_test;")
client.close

ActiveRecord::Base.configurations = { 'test' => { adapter: 'mysql2', database: 'simple_mysql_partitioning_test', host: '127.0.0.1' } }
ActiveRecord::Base.establish_connection :test

class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:daily_reports, id: false, primary_key: %i[id day]) do |t|
      t.integer :id
      t.date   :day
      t.text   :imp
    end
    partition = "ALTER TABLE daily_reports
                  PARTITION BY RANGE  COLUMNS(`day`)  (
                  PARTITION p201704 VALUES LESS THAN ('2018-05-01') ENGINE = InnoDB,
                  PARTITION p999999 VALUES LESS THAN (MAXVALUE) ENGINE = InnoDB
             )
    "
    execute partition
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up