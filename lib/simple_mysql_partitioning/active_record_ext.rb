module SimpleMySQLPartitioning
  module ActiveRecordExt
    def self.included(model)
      model.extend ClassMethods
    end

    module ClassMethods
      def partition(column, opt = {})
        # TODO
        @@partition_config = column#::Config.new(column: column, by: opt[:by], type: opt[:type])
      end

      def partition_config
        @@partition_config
      end
    end
  end
end

#ActiveRecord::Base.send :include, SimpleMySQLPartitioning::ActiveRecordExt