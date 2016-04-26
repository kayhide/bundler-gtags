lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundler-gtags/version'

Gem::Specification.new do |spec|
  spec.name          = 'bundler-gtags'
  spec.version       = Bundler::Gtags::VERSION
  spec.authors       = ['kayhide']
  spec.email         = ['kayhide@gmail.com']

  spec.summary       = 'GNU Global (gtags) utility.'
  spec.description   = 'GNU Global (gtags) utility. Create gtags for all bundled gems and manage GTAGSLIBPATH using direnv.'
  spec.homepage      = 'https://github.com/kayhide/bundler-gtags'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'bundler', '~> 1.11'
  spec.add_runtime_dependency 'colored'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
