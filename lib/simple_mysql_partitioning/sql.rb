module SimpleMySQLPartitioning
  class SQL
    PARTITION_RANGE_LESS_VALUE =
      'PARTITION %{name} VALUES LESS THAN %{less_than}'.freeze

    class << self
      def exists_sql(table_name, partition_name)
        "SELECT\n            table_schema,\n            table_name,\n            partition_name,\n            partition_ordinal_position, table_rows\n          FROM information_schema.partitions\n          WHERE table_name='#{table_name}'\n            AND partition_name='#{partition_name}'\n          LIMIT 1;"
      end

      def create_sql(table_name, column, pairs_name_with_value)
        alter = "ALTER TABLE #{table_name} PARTITION BY RANGE COLUMNS(#{column})"

        partitions = pairs_name_with_value.map do |pair|
          format(
            PARTITION_RANGE_LESS_VALUE,
            name: pair.first,
            less_than: less_than(pair.last)
          )
        end

        "#{alter} (#{partitions.join(',')})"
      end

      def add_sql(table_name, partition_name, value)
        "ALTER TABLE #{table_name}\n           ADD PARTITION ( PARTITION #{partition_name} VALUES LESS THAN #{less_than(value)});"
      end

      def reorganize_sql(table_name, partition_name, value, reorganize_partition_name, max_value = 'MAXVALUE')
        "ALTER TABLE #{table_name}\n           REORGANIZE PARTITION #{reorganize_partition_name} INTO (\n             PARTITION #{partition_name} VALUES LESS THAN #{less_than(value)},\n             PARTITION #{reorganize_partition_name} VALUES LESS THAN #{less_than(max_value)}\n           );"
      end

      def parge_sql(table_name, partition_name)
        "ALTER TABLE #{table_name} DROP PARTITION #{partition_name};"
      end

      private

        def less_than(value)
          value == 'MAXVALUE' ? 'MAXVALUE' : "('#{value}')"
        end
    end
  end
end
