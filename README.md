# SimpleMysqlPartitioning

[![Build Status](https://travis-ci.org/Andryu/simple_mysql_partitioning.svg?branch=master)](https://travis-ci.org/Andryu/simple_mysql_partitioning)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/simple_mysql_partitioning`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_mysql_partitioning', '~> 1.0.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_mysql_partitioning

## Usage

``` ruby
class DailyReport < ActiveRecord::Base
  include SimpleMySQLPartitioning

  # arg1: column
  # type: partitiong type
  partitioning_by :day, type: :range
end


# partition name, less than value
pairs_name_with_values = [
  ['p201808', '2018-09-01']
]

# create partition
DailyReport.partition.create(pairs_name_with_values)

NOTE: No support MAXVALUE, please use add method after created partition.

# add partition
DailyReport.partition.add(pairs_name_with_values)

# reorganize partition
# If you want to reorganize partition, use this method and set reorganize partition name to second arg.
# Reorganize partitiong default value is 'MAXVALUE'.
DailyReport.partition.reorganize(pairs_name_with_values, 'p999999', 'MAXVALUE')

# drop
DailyReport.partition.drop('p201808')

# exists?
DailyReport.partition.exists?('p201808')
```

We support only range partitioning.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### How to test for local

```
BUNDLE_GEMFILE=gemfiles/Gemfile** bundle exec rspec
ex) BUNDLE_GEMFILE=gemfiles/Gemfile.rails-6.0 bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Andryu/simple_mysql_partitioning.
