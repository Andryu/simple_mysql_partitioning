lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_mysql_partitioning/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_mysql_partitioning'
  spec.version       = SimpleMysqlParitioning::VERSION
  spec.authors       = ['Shunsuke Andoh']
  spec.email         = ['shunsuke.andoh@gmail.com']

  spec.summary       = ' Generate partitioning sql for mysql'
  spec.description   = ' simple generate partition sql'
  spec.homepage      = 'https://github.com/Andryu/simple_mysql_partitioning'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency 'activerecord', '> 4.2.5'
  spec.add_development_dependency 'mysql2', '>= 0.5.0'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
end
