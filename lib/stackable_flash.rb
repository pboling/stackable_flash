# Only support Rails 3+?
#require 'action_dispatch'
require "stackable_flash/version"
require "stackable_flash/config"
require "stackable_flash/flash_stack"
require "stackable_flash/stack_layer"

module StackableFlash

  require 'stackable_flash/railtie' if defined?(Rails)

  class << self
    attr_accessor :stacking
  end
  self.stacking = true # Turn on stacking by default

  # Regardless of the value of StackableFlash.stacking you can do a local override to force stacking.
  #
  #  StackableFlash.stacked do
  #     flash[:notice] = 'a simple string'  # You can continue to use flash as if this gem did not exist
  #     flash[:notice] << 'another'         # will stack the strings
  #     flash[:notice]                      # => ['a simple string','another'],
  #     # Uses the default :stack_with_proc to transform
  #     flash[:notice].stack                # => "a simple string<br/>another" (default config uses <br/>),
  #     flash[:notice] = ''                 # will overwrite everything above, and set back to empty string
  #  end
  #
  #  StackableFlash.stacked({:stack_with_proc => Proc.new {|arr| arr.map! {|x| "<p>#{x}</p>"}.join } } ) do
  #    flash[:error] = 'original'
  #    flash[:error] << 'message'
  #    flash[:error]        # => ['original','message']
  #    # Uses the custom :stack_with_proc above to transform
  #    flash[:error].stack  # => '<p>original</p><p>message</p>'
  #  end
  #
  def self.stacked(config_options = {}, &block)
    flashing({:forcing => true}) do
      original = StackableFlash::Config.config.dup
      StackableFlash::Config.config.merge!(config_options)
      yield
      StackableFlash::Config.config = original
    end
  end

  # Regardless of the value of StackableFlash.stacking you can do a local override to force non-stacking.
  #
  # StackableFlash.not_stacked do
  #   flash[:notice] = 'a simple string'  # You can continue to use flash as if this gem did not exist
  #   flash[:notice] << 'another'         # will concatenate the strings
  #   flash[:notice]                      # => "a simple stringanother"
  #   flash[:notice].stack                # => "a simple stringanother"
  #   flash[:notice] = ''                 # will overwrite everything above, and set back to empty string
  # end
  #
  def self.not_stacked &block
    flashing({:forcing => false}) do
      yield
    end
  end

  def self.flashing(options, &block)
    return false unless block_given?
    original = StackableFlash.stacking
    StackableFlash.stacking = options[:forcing]
    yield
    StackableFlash.stacking = original
  end

end
