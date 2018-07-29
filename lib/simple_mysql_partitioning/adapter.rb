module SimpleMySQLPartitioning
  module Adapter
    def self.included(model)
      model.extend ClassMethods
    end

    module ClassMethods
      def partitioning_by(column, type:)
        @partition_config = { column: column, type: type }
        @partition = "SimpleMySQLPartitioning::#{type.to_s.classify}".constantize.new(self)
      end

      def partition
        @partition
      end

      def partition_config
        @partition_config
      end
    end
  end
end
