# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "open_project/meeting/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-meeting"
  s.version     = OpenProject::Meeting::VERSION
  s.authors     = "Finn GmbH"
  s.email       = "info@finn.de"
  s.homepage    = "http://www.finn.de"
  s.summary     = "This OpenProject plugin adds a meeting module with functionality to plan an agenda and save the minutes of a meeting."
  s.description = "This OpenProject plugin adds a meeting module with functionality to plan an agenda and save the minutes of a meeting."

  s.files = Dir["{app,config,db,lib}/**/*", "CHANGELOG.md", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.9"

  s.add_development_dependency "factory_girl_rails", "~> 4.0"
end
