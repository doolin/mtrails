$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "subscribem/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "subscribem"
  s.version     = Subscribem::VERSION
  s.authors     = ["Your name"]
  s.email       = ["Your email"]
  s.homepage    = "http://dool.in"
  s.summary     = "Summary of Subscribem."
  s.description = "Description of Subscribem."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.4"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "3.0.1"
  s.add_development_dependency "capybara", "2.3.0"
  s.add_development_dependency "launchy"
  s.add_development_dependency "pry"
end