module SimpleMySQLPartitioning
  class SQL
    def initialize(table_name)
      @table_name = table_name
    end

    def exist_sql(partition_name)
        "SELECT
            table_schema,
            table_name,
            partition_name,
            partition_ordinal_position,
            table_rows
          FROM information_schema.partitions
          WHERE table_name='#{@table_name}'
            AND partition_name='#{partition_name}'
          LIMIT 1;"
      end

      def add_sql(partition_name, value)
        "ALTER TABLE #{@table_name}
            ADD PARTITION ( PARTITION #{partition_name}
            VALUES LESS THAN ('#{value}'));"
      end

      def reorganize_sql(partition_name, value, reorganize_partition_name, max_value = 'MAXVALUE')
        "ALTER TABLE #{@table_name}
            REORGANIZE PARTITION #{reorganize_partition_name} INTO (
            PARTITION #{partition_name} VALUES LESS THAN ('#{value}'),
            PARTITION #{reorganize_partition_name} VALUES LESS THAN #{max_value});"
      end

      def parge_sql(partition_name)
        "ALTER TABLE #{@table_name} DROP PARTITION #{partition_name};"
      end
  end
end