
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "data_sense/version"

Gem::Specification.new do |spec|
  spec.name          = "data_sense"
  spec.version       = DataSense::VERSION
  spec.authors       = ["James Inman"]
  spec.email         = ["james@jamesinman.co.uk"]

  spec.summary       = %{Provides a Ruby interface to the DataSense OneRoster v1.1 API}
  spec.homepage      = "https://github.com/safeguardingmonitor/data_sense"
  spec.license       = "Apache 2.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "faraday", "< 1.0"
  spec.add_dependency "activesupport", "> 5.0"
  spec.add_dependency "webmock", "> 3.4.0"
end
