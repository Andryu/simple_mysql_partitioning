require 'simple_mysql_partitioning/version'
require 'active_record'
require 'mysql2'
require 'simple_mysql_partitioning/adapter'
require 'simple_mysql_partitioning/sql'
require 'simple_mysql_partitioning/range'
require 'simple_mysql_partitioning/base_partitioning'

module SimpleMySQLPartitioning
  # Your code goes here...
  class << self
    def included(klass)
      klass.send :include, SimpleMySQLPartitioning::Adapter
    end
  end
end
