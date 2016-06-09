$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "capistrano/confirm_branch/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "capistrano_confirm_branch"
  s.version     = Capistrano::ConfirmBranch::VERSION
  s.authors     = ["Jordan Byron"]
  s.email       = ["jordan.byron@gmail.com"]
  s.homepage    = "https://github.com/madriska/capistrano_confirm_branch"
  s.summary     = "Requires confirmation before switching deployed branches"
  s.description = "Requires confirmation before switching deployed branches"

  s.files = Dir["lib/**/*"] +
    %w{Rakefile README.md LICENSE}

  s.add_dependency "capistrano", '>= 3.2.0'
  s.add_dependency "highline"
end
