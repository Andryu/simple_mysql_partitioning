lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_mysql_partitioning/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_mysql_partitioning'
  spec.version       = SimpleMySQLPartitioning::VERSION
  spec.authors       = ['Shunsuke Andoh']
  spec.email         = ['shunsuke.andoh@gmail.com']

  spec.summary       = ' Generate partitioning sql for mysql'
  spec.description   = ' simple generate partition sql'
  spec.homepage      = 'https://github.com/Andryu/simple_mysql_partitioning'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency 'activerecord', '>= 6.1.0', '< 8.0'
  spec.add_dependency 'activesupport', '>= 6.1.0', '< 8.0'
  # Pin concurrent-ruby to < 1.3.5 for Rails 6.1 compatibility
  # concurrent-ruby 1.3.5+ removed logger dependency causing NameError with Rails 6.1
  spec.add_dependency 'concurrent-ruby', '~> 1.3.0', '< 1.3.5'
  spec.add_development_dependency 'mysql2', '~> 0.5.6'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.13'
end
