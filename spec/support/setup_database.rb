host = ENV['MYSQL_DB_HOST'] || '127.0.0.1'
client = Mysql2::Client.new(host: host, username: 'root', password: '')
client.query('DROP DATABASE IF EXISTS simple_mysql_partitioning_test;')
client.query('CREATE DATABASE simple_mysql_partitioning_test;')
client.close

# Rails 6.1+ compatible configuration
if ActiveRecord.version >= Gem::Version.new('7.1')
  # Rails 7.1+ uses a different configuration system
  ActiveRecord::Base.configurations = ActiveRecord::DatabaseConfigurations.new(YAML.load_file('spec/dummy/database.yml'))
  config = ActiveRecord::Base.configurations.configs_for(env_name: 'test').first.configuration_hash
else
  ActiveRecord::Base.configurations = YAML.load_file('spec/dummy/database.yml')
  config = ActiveRecord::Base.configurations['test']
end

config['host'] = host
ActiveRecord::Base.establish_connection(config)

# Rails 6.1+ compatible migration
# Use versioned migration for better compatibility
class CreateAllTables < ActiveRecord::Migration[6.1]
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
