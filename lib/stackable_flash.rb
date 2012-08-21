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
  # StackableFlash.stacked do
  #   flash[:notice] = 'a simple string'  # Use flash as if this gem did not exist
  #   flash[:notice] = 'another'          # will stack the strings
  #   flash[:notice] # => ['a simple string','another'],
  #                  #    but returned as "a simple string<br/>another" with default config
  # end
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
  #   flash[:notice] = 'a simple string'  # Use flash as if this gem did not exist
  #   flash[:notice] = ''                 # will overwrite the string above
  #   flash[:notice] # => ''
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
