stackable_flash
===============

* Allows flashes to stack intelligently like arrays.
* Follows the *principle of least surprise* for existing behavior of Rails' FlashHash.

| Project                 |  Stackable Flash  |
|------------------------ | ----------------- |
| gem name                |  stackable_flash  |
| license                 |  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) |
| expert support          |  [![Get help on Codementor](https://cdn.codementor.io/badges/get_help_github.svg)](https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github) |
| download rank           |  [![Total Downloads](https://img.shields.io/gem/rt/stackable_flash.svg)](https://rubygems.org/gems/stackable_flash) |
| version                 |  [![Gem Version](https://badge.fury.io/rb/stackable_flash.png)](http://badge.fury.io/rb/stackable_flash) |
| dependencies            |  [![Dependency Status](https://gemnasium.com/pboling/stackable_flash.png)](https://gemnasium.com/pboling/stackable_flash) |
| code quality            |  [![Code Climate](https://codeclimate.com/github/pboling/stackable_flash.png)](https://codeclimate.com/github/pboling/stackable_flash) |
| inline documenation     |  [![Inline docs](http://inch-ci.org/github/pboling/stackable_flash.png)](http://inch-ci.org/github/pboling/stackable_flash) |
| continuous integration  |  [![Build Status](https://secure.travis-ci.org/pboling/stackable_flash.png?branch=master)](https://travis-ci.org/pboling/stackable_flash) |
| test coverage           |  [![Coverage Status](https://coveralls.io/repos/pboling/stackable_flash/badge.png)](https://coveralls.io/r/pboling/stackable_flash) |
| homepage                |  [on Github.com][homepage] |
| documentation           |  [on Rdoc.info][documentation] |
| live chat               |  [![Join the chat at https://gitter.im/pboling/stackable_flash](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/pboling/stackable_flash?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) |
| Spread ~♡ⓛⓞⓥⓔ♡~      |  [on Coderwall][coderwall] |

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74
[railsbling]: http://www.railsbling.com
[peterboling]: http://www.peterboling.com
[coderwall]: http://coderwall.com/pboling
[documentation]: http://rdoc.info/github/pboling/stackable_flash/frames
[homepage]: https://github.com/pboling/stackable_flash

## Description

Stackable Flash overrides the `:[]=` method of Rails' FlashHash with the result being that each flash key is an array.
It is designed following the "Principle of least surprise", so in most ways the flash works as it always has.
Only now you can push things onto the array with `:<<`, and generally interact with the flash as an array.
In order to be as compatible as possible with existing implementations of the FlashHash on websites, `:[]=` will still
replace the entire object at that key.

## Installation

Add this line to your application's Gemfile:

    gem 'stackable_flash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stackable_flash

## Config (Optional)

In an environment file, or application.rb

    # Here are a few ideas (Don't do them all, pick one):
    # You can use a lambda instead of a proc
    StackableFlash::Config.configure do
      # Leave it as an array
      config[:stack_with_proc] = Proc.new {|arr| arr }
      # Make a set of statements separated by br tags
      config[:stack_with_proc] = Proc.new {|arr| arr.join('<br/>') }   # THIS IS DEFAULT IF LEFT UNCONFIGURED
      # Make a set of p tags:
      config[:stack_with_proc] = Proc.new {|arr| arr.map! {|x| "<p>#{x}</p>"}.join }
      # Make an unordered list of tags:
      config[:stack_with_proc] = Proc.new {|arr| '<ul>' + arr.map! {|x| "<li>#{x}</li>"}.join + '</ul>' }
    end

## Usage

When turned on all flashes can be interacted with as arrays.

    flash[:notice] = 'First message'              # Will have the same affect that pushing it onto an array would
    flash[:notice] << 'Second message'            # No need to initialize first, or test to see if responds to :<<
    flash[:notice] |= 'Third message'             # Will add this message only if unique in the stack
    flash[:notice] += ['Fourth','Fifth']          # Will add all of the messages onto the stack individually.

    flash[:notice] # is now: ['First message','Second message','Third message','Fourth','Fifth']

But StackableFlash preserves existing functionality for code you already have written.

    flash[:notice] += ' Appended'                  # Will append a message to the top/last message on the stack.

    flash[:notice] # is now: ['First message','Second message','Third message','Fourth','Fifth Appended']

    flash[:notice] = 'Overwrite'

    flash[:notice] # is now: ['Overwrite']

It is on by default.  To turn it off:

    StackableFlash.stacked = false

To turn it back on:

    StackableFlash.stacked = true

You can even start out with it off set a flash, turn it on, and add to the stack:

    StackableFlash.stacked = false
    flash[:notice] = 'string'
    StackableFlash.stacked = true
    flash[:notice] << 'string'

There are block helpers which I am sure some enterprising individual will have a use for:

    StackableFlash.stacked do
      flash[:notice] = 'a simple string'  # You can continue to use flash as if this gem did not exist
      flash[:notice] << 'another'         # will stack the strings
      flash[:notice]                      # => ['a simple string','another'],
      # Uses the :stack_with_proc to transform
      flash[:notice].stack                # => "a simple string<br/>another" (default config uses <br/>),
      flash[:notice] = ''                 # will overwrite everything above, and set back to empty string
    end

    StackableFlash.stacked({:stack_with_proc => Proc.new {|arr| arr.map! {|x| "<p>#{x}</p>"}.join } } ) do
      flash[:error] = 'original'
      flash[:error] << 'message'
      flash[:error]        # => ['original','message']
      flash[:error].stack  # => '<p>original</p><p>message</p>'
    end

And

    StackableFlash.not_stacked do
      flash[:notice] = 'original'
      flash[:notice] << ' message'
      flash[:notice]        # => 'original message'
      # Uses the :stack_with_proc to transform
      flash[:notice].stack  # => NoMethodError !!!
    end

## Sightings

This gem is used by the [cacheable_flash](https://github.com/pboling/cacheable-flash) gem to provide stacking flashes.
You can check it out for a working example.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
6. Create new Pull Request

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver].
Violations of this scheme should be reported as bugs. Specifically, 
if a minor or patch version is released that breaks backward 
compatibility, a new version should be immediately released that
restores compatibility. Breaking changes to the public API will 
only be introduced with new major versions.

As a result of this policy, you can (and should) specify a 
dependency on this gem using the [Pessimistic Version Constraint][pvc] with two digits of precision. 

For example:

    spec.add_dependency 'stackable_flash', '~> 4.0'

[semver]: http://semver.org/
[pvc]: http://docs.rubygems.org/read/chapter/16#page74

## Copyright

Licensed under the MIT License.

* Copyright (c) 2012-17 Peter H. Boling (http://railsbling.com). See LICENSE for further details.
