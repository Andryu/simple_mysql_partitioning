# SimpleMysqlPartitioning

[![Build Status](https://travis-ci.org/Andryu/simple_mysql_partitioning.svg?branch=master)](https://travis-ci.org/Andryu/simple_mysql_partitioning)

SimpleMysqlPartitioning is a small ActiveRecord extension that makes it easy to manage MySQL RANGE COLUMNS partitions from your Rails models. It currently targets modern Rails/ActiveRecord (7.1+) and Ruby 3.0+ environments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_mysql_partitioning', '~> 2.0'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install simple_mysql_partitioning
```

## Usage

```ruby
class DailyReport < ActiveRecord::Base
  include SimpleMySQLPartitioning

  # arg1: column
  # type: partition type
  partitioning_by :day, type: :range
end

# partition name, less than value
pairs_name_with_values = [
  ['p201808', '2018-09-01']
]

# create partition
DailyReport.partition.create(pairs_name_with_values)

# add partition (including MAXVALUE support)
DailyReport.partition.add(pairs_name_with_values)

# reorganize partition
# If you want to reorganize partition, use this method and set reorganize partition name to second arg.
# Reorganize partition default value is 'MAXVALUE'.
DailyReport.partition.reorganize(pairs_name_with_values, 'p999999', 'MAXVALUE')

# drop
DailyReport.partition.drop('p201808')

# exists?
DailyReport.partition.exists?('p201808')
```

We currently support RANGE partitioning for MySQL.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing against specific Rails versions

```
BUNDLE_GEMFILE=gemfiles/Gemfile.rails-7.1 bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Andryu/simple_mysql_partitioning.
