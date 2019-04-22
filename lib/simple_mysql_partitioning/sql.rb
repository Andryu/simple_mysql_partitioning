module SimpleMySQLPartitioning
  class SQL

    PARTITION_RANGE_LESS_VALUE =
      'PARTITION %{name} VALUES LESS THAN ("%{value}")'.freeze

    class << self
      def exists_sql(table_name, partition_name)
        "SELECT
            table_schema,
            table_name,
            partition_name,
            partition_ordinal_position, table_rows
          FROM information_schema.partitions
          WHERE table_name='#{table_name}'
            AND partition_name='#{partition_name}'
          LIMIT 1;"
      end

      def create_sql(table_name, column, pairs_name_with_value, max_value = true)
        alter = "ALTER TABLE #{table_name} PARTITION BY RANGE COLUMNS(#{column})"

        partitions = pairs_name_with_value.map do |pair|
          format(
            PARTITION_RANGE_LESS_VALUE,
            name: pair.first,
            value: pair.last
          )
        end

        alter + ' ' + "(#{partitions.join(',')})"
      end

      def add_sql(table_name, partition_name, value)
        "ALTER TABLE #{table_name}
           ADD PARTITION ( PARTITION #{partition_name} VALUES LESS THAN #{less_than(value)});"
      end

      def reorganize_sql(table_name, partition_name, value, reorganize_partition_name, max_value = 'MAXVALUE')
        "ALTER TABLE #{table_name}
           REORGANIZE PARTITION #{reorganize_partition_name} INTO (
             PARTITION #{partition_name} VALUES LESS THAN ('#{value}'),
             PARTITION #{reorganize_partition_name} VALUES LESS THAN #{less_than(max_value)}
           );"
      end

      def parge_sql(table_name, partition_name)
        "ALTER TABLE #{table_name} DROP PARTITION #{partition_name};"
      end

      private

        def less_than(value)
          value == 'MAXVALUE' ? value : "('#{value}')"
        end
    end
  end
end
