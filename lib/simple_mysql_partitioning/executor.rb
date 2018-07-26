require 'active_record'
require 'simple_mysql_partitioning/sql'

module SimpleMySQLPartitioning
  class Executor
    def initialize(klass, partition_name)
      @klass = klass
      @table_name = @klass.table_name
      @partition_name = partition_name
    end

    def add(less_than_value)
      return if exist?
      add_partition_sql = SQL.add_sql(@table_name, @partition_name, less_than_value)
      @klass.connection.execute(add_partition_sql)
    end

    def reorganize(less_than_value, reorganize_partition_name)
      return if exist?
      @klass.connection.execute(
        SQL.reorganize_sql(
          @table_name,
          @partition_name, less_than_value,
          reorganize_partition_name
        )
      )
    end

    def exist?
      @klass.connection.select_all(
        SQL.exist_sql(@table_name, @partition_name)
      ).to_hash.present?
    end

    def drop
      return unless exist?
      @klass.connection.execute(SQL.parge_sql(@table_name, @partition_name))
    end
  end
end
