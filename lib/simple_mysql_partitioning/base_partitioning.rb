require 'active_record'
require 'simple_mysql_partitioning/sql'

module SimpleMySQLPartitioning
  class BasePartitioning
    attr_reader :klass, :table_name

    def initialize(klass)
      @klass = klass
      @table_name = klass.table_name
    end

    def exists?(partition_name)
      klass.connection.select_all(
        SQL.exists_sql(table_name, partition_name)
      ).to_hash.present?
    end

    def drop(partition_name)
      klass.connection.execute(SQL.parge_sql(table_name, partition_name))
    end
  end
end