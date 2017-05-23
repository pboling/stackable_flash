# -*- encoding: utf-8 -*-
require File.expand_path('../lib/stackable_flash/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Peter Boling']
  gem.email         = ['peter.boling@gmail.com']
  gem.description   = %q{Allows flashes to stack intelligently, while preserving existing behavior of the Rails FlashHash}
  gem.summary       = %q{Worried that your flash may not be stacked?  This is the answer.}
  gem.homepage      = 'https://github.com/pboling/stackable_flash'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'stackable_flash'
  gem.require_paths = ['lib']
  gem.version       = StackableFlash::VERSION

  # Development Dependencies

  # http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#ruby-versions
  if RUBY_VERSION <= '2.0' # 1.9.3-p551
    gem.add_development_dependency(%q<rails>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<activesupport>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<rspec-rails>, ['2.11.0', '< 2.14.0'])
    gem.add_development_dependency(%q<reek>, ['>= 1.2.8', '< 3.0'])
  elsif RUBY_VERSION <= '2.1' # 2.0.0-p648
    gem.add_development_dependency(%q<rails>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<activesupport>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<rspec-rails>, ['2.11.0', '< 2.14.0'])
    gem.add_development_dependency(%q<reek>, ['>= 1.2.8', '< 4.0'])
  elsif RUBY_VERSION <= '2.2' # 2.1.2
    gem.add_development_dependency(%q<rails>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<activesupport>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<rspec-rails>, ['2.99'])
    gem.add_development_dependency(%q<reek>, ['>= 4.6'])
  elsif RUBY_VERSION <= '2.3' # 2.2.7
    gem.add_development_dependency(%q<rails>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<activesupport>, ['> 3', '< 4.0'])
    gem.add_development_dependency(%q<rspec-rails>, ['2.99'])
    gem.add_development_dependency(%q<reek>, ['>= 4.6'])

    # LoadError: Ruby 2.2+ has removed test/unit from the core library. Rails requires this as a dependency. Please add test-unit gem to your Gemfile: `gem 'test-unit', '~> 3.0'` (cannot load such file -- test/unit)"
    gem.add_development_dependency(%q<test-unit>, ['3.0'])
  end

  gem.add_development_dependency(%q<roodi>, ['>= 2.1.0'])
  gem.add_development_dependency(%q<rake>, ['>= 0'])

end

