client = Mysql2::Client.new(host: 'mysql', username: 'root', password: '')
client.query('CREATE DATABASE simple_mysql_partitioning_test;')
client.close

ActiveRecord::Base.configurations = YAML.load_file('spec/dummy/database.yml')
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])

class CreateAllTables < ActiveRecord::Migration[4.2]
  def self.up
    create_table(:daily_reports, id: false, primary_key: %i[id day]) do |t|
      t.integer :id
      t.date   :day
      t.text   :imp
    end
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
