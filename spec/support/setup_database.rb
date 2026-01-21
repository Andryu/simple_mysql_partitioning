host = ENV['MYSQL_DB_HOST'] || '127.0.0.1'
client = Mysql2::Client.new(host: host, username: 'root', password: '')
client.query('DROP DATABASE IF EXISTS simple_mysql_partitioning_test;')
client.query('CREATE DATABASE simple_mysql_partitioning_test;')
client.close

# Rails 6.1+ compatible configuration
require 'erb'
require 'yaml'
yaml_content = ERB.new(File.read('spec/dummy/database.yml')).result
yaml_config = YAML.safe_load(yaml_content, aliases: true)

if ActiveRecord.version >= Gem::Version.new('7.1')
  # Rails 7.1+ uses a different configuration system
  db_configs = ActiveRecord::DatabaseConfigurations.new(yaml_config)
  ActiveRecord::Base.configurations = db_configs
  config = db_configs.configs_for(env_name: 'test').first.configuration_hash.dup
else
  ActiveRecord::Base.configurations = yaml_config
  config = yaml_config['test'].dup
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
