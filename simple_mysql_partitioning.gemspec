
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_mysql_partitioning/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_mysql_partitioning"
  spec.version       = SimpleMysqlParitioning::VERSION
  spec.authors       = ["Shunsuke Andoh"]
  spec.email         = ["shunsuke.andoh@gmail.com"]

  spec.summary       = %q{ Generate partitioning sql for mysql}
  spec.description   = %q{ simple generate partition sql}
  spec.homepage      = "https://github.com/Andryu"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "http://mygemserver.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ["> 3.0", "< 5.0"]
  spec.add_development_dependency "mysql2", "~> 0.3.21"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
