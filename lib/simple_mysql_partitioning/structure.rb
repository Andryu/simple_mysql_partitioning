module SimpleMySQLPartitioning
  class Structure
    Config = Struct.new(:column, :by, :type) do
      def initialize
        super(column: column, by: by, type: type)
      end
    end
  end
end