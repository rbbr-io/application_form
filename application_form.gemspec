# frozen_string_literal: true

require_relative 'lib/application_form/version'

Gem::Specification.new do |spec|
  spec.name          = 'application_form'
  spec.version       = ApplicationForm::VERSION
  spec.authors       = ['Kirill Mokevnin', 'Ivan Nemytchenko']
  spec.email         = ['nemytchenko@gmail.com']

  spec.summary       = 'Painless forms for ActiveRecord'
  spec.description   = 'Lightweight inheritance based forms solution'
  spec.homepage      = 'https://github.com/rbbr-io/application_form'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/rbbr-io/application_form.git'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('activesupport', '>= 3')

  spec.add_development_dependency('actionpack', '>= 5')
  spec.add_development_dependency('activemodel', '>= 5')
end
