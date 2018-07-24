require 'active_record'

module SimpleMySQLPartitioning
  class Executor
    def initialize(klass, partition_name)
      @klass = klass
      @table_name = @klass.table_name
      @partition_name = partition_name
    end

    def add(less_than_value)
      add_partition_sql = add_sql(@table_name, @partition_name, less_than_value)
      @klass.connection.execute(add_partition_sql)
    end

    def reorganize(less_than_value, reorganize_partition_name)
      @klass.connection.execute(
        reorganize_sql(
          @table_name,
          @partition_name, less_than_value,
          reorganize_partition_name
        )
      )
    end

    def exist?
      @klass.connection.select_all(
        exist_sql(@table_name, @partition_name)
      ).to_hash.present?
    end

    def drop
      @klass.connection.execute(parge_sql(@table_name, @partition_name))
    end
  end
end
