# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'devise-pki/version'

Gem::Specification.new do |s|
  s.name         = "devise-pki"
  s.version      = DevisePKI::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["David Middleton"]
  s.email        = ["david.middleton@gmail.com"]
  s.homepage     = "https://github.com/peon374/devise-pki"
  s.summary      = "A PKI keychain schema for devise"
  s.description  = "Adds support for public key infrastructure to the devise user model. This code is alpha and until this message changes it is not fit for any purpose."
  s.files        = Dir["lib/**/*"] + %w[LICENSE README.rdoc]
  s.require_path = "lib"
  s.rdoc_options = ["--main", "README.rdoc", "--charset=UTF-8"]
  
  s.required_ruby_version     = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.6'
  
  s.add_development_dependency('bundler', '~> 1.0.7')
  
  {
    'rails'  => ['>= 3.0.0', '< 3.2'],
    'devise' => '~> 1.4.1'
  }.each do |lib, version|
    s.add_runtime_dependency(lib, *version)
  end
  
end
