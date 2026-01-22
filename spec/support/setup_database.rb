host = ENV['MYSQL_DB_HOST'] || '127.0.0.1'
client = Mysql2::Client.new(host: host, username: 'root', password: '')
client.query('DROP DATABASE IF EXISTS simple_mysql_partitioning_test;')
client.query('CREATE DATABASE simple_mysql_partitioning_test;')
client.close

# Rails 6.1+ compatible configuration
require 'erb'
require 'yaml'
yaml_content = ERB.new(File.read('spec/dummy/database.yml')).result
# For Ruby 3.0+, use YAML.unsafe_load for ERB-evaluated YAML
if YAML.respond_to?(:unsafe_load)
  yaml_config = YAML.unsafe_load(yaml_content)
else
  yaml_config = YAML.load(yaml_content)
end

if ActiveRecord.version >= Gem::Version.new('7.1')
  # Rails 7.1+ uses a different configuration system
  db_configs = ActiveRecord::DatabaseConfigurations.new(yaml_config)
  ActiveRecord::Base.configurations = db_configs
  test_config = db_configs.configs_for(env_name: 'test').first
  raise 'No test database configuration found' unless test_config
  config = test_config.configuration_hash.dup
else
  ActiveRecord::Base.configurations = yaml_config
  config = yaml_config['test'].dup
end

config['host'] = host
ActiveRecord::Base.establish_connection(config)

# Rails 6.1+ compatible migration
# Create table without primary key, then add composite primary key
class CreateAllTables < ActiveRecord::Migration[6.1]
  def self.up
    create_table(:daily_reports, id: false) do |t|
      t.integer :id, null: false
      t.date   :day, null: false
      t.text   :imp
    end

    # Add composite primary key using raw SQL (works across all Rails 6.1+)
    execute 'ALTER TABLE daily_reports ADD PRIMARY KEY (id, day)'
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
