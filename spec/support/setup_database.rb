host = ENV['MYSQL_DB_HOST'] || '127.0.0.1'
client = Mysql2::Client.new(host: host, username: 'root', password: '')
client.query('CREATE DATABASE simple_mysql_partitioning_test;')
client.close

ActiveRecord::Base.configurations = YAML.load_file('spec/dummy/database.yml')
config = ActiveRecord::Base.configurations['test']
config['host'] = host
ActiveRecord::Base.establish_connection(config)

# 4.2と5.xで指定の仕方が変わったため
# 参考: https://github.com/sue445/activerecord-compatible_legacy_migration/blob/v0.1.1/lib/active_record/compatible_legacy_migration.rb
# Rails 5.0以降だと ActiveRecord::Migration[4.2] を、Rails 5未満だと ActiveRecord::Migration を返す
class CreateAllTables < ActiveRecord::CompatibleLegacyMigration.migration_class
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
