Gem::Specification.new do |s|
  s.name        = 'SodaCan'
  s.version     = '0.0.1'
  s.date        = '2013-04-06'
  s.summary     = "SOQL Wrapper for JSON Soda 2 interfaces"
  s.description = "Wrapper to make ActiveRecord type queries on Soda2 interfaces."
  s.authors     = ["Trevor John", "Tyler Heck"]
  s.email       = 'tyler.heck@gmail.com'
  s.files       = %w(Gemfile README.md Rakefile SodaCan.gemspec)
  s.files       += Dir.glob("lib/**/*.rb")
  s.files       += Dir.glob("spec/*_spec.rb")
  s.add_runtime_dependency "json", ["= 1.7.7"]
  s.add_runtime_dependency "rest-client", ["= 1.6.7"]
  s.homepage    =
    'http://rubygems.org/gems/sodacan'
end
