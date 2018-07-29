require 'active_record'
require 'simple_mysql_partitioning/sql'
require 'simple_mysql_partitioning/base_partitioning'

module SimpleMySQLPartitioning
  class Range < BasePartitioning
    def add(pairs_name_with_value)
      pairs_name_with_value.map do |pair|
        add_partition_sql = SQL.add_sql(table_name, pair.first, pair.last)
        klass.connection.execute(add_partition_sql)
      end
    end

    def reorganize(pairs_name_with_value, reorganize_partition_name, reorganize_partition_value = 'MAXVALUE')
      pairs_name_with_value.map do |pair|
        klass.connection.execute(
          SQL.reorganize_sql(
            table_name,
            pair.first, pair.last,
            reorganize_partition_name,
            reorganize_partition_value
          )
        )
      end
    end
  end
end
