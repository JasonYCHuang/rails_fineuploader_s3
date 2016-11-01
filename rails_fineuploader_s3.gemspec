# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_fineuploader_s3/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_fineuploader_s3"
  spec.version       = RailsFineuploaderS3::VERSION
  spec.authors       = ["jasonych99"]
  spec.email         = ["jasonych99@gmail.com"]

  spec.summary       = %q{Rails sever-side app for fineuploader-S3}
  spec.description   = %q{When using fineuploader in Front-end, you need this gem to provide a correct signature.}
  spec.homepage      = "https://github.com/JasonYCHuang/rails_fineuploader_s3"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.1"

  spec.add_dependency "aws-sdk", "~> 2"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
