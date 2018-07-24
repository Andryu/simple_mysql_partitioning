require 'bundler/setup'
require 'simple_mysql_partitioning'

Dir["#{File.dirname(__FILE__)}/support/setup_database.rb"].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:all) do
    Dir["#{File.dirname(__FILE__)}/support/drop_database.rb"].each { |f| require f }
  end
end
