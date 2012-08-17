module StackableFlash
  class Config

    class << self
      attr_accessor :config
    end

    DEFAULTS = {
      # Specify how stacked flashes at the same key (e.g. :notice, :errors) should be returned:
      #
      # Example:
      #   flash[:notice] = 'Message 1'
      #   flash[:notice] << 'Message 2'
      #
      # the flash[:notice] object now looks like when :stack_with_proc => lambda { |arr| arr }:
      #
      #   flash[:notice] # => ['Message 1','Message 2']
      #
      # the flash[:notice] object now looks like when :stack_with_proc => lambda { |arr| arr.join('<br/>') }:
      #
      #   flash[:notice] # => "Message 1<br/>Message 2"
      #
      # The default leaves the flash as a string of all the flashes joined by br tags,
      #   to preserve compatibility with existing javascript, and/or views
      #   that expect the flashes as a single string.
      :stack_with_proc => Proc.new { |arr| arr.join('<br/>') }
    }

    #cattr_reader :config
    #cattr_writer :config

    self.config ||= DEFAULTS
    def self.configure &block
      yield @@config
    end

  end
end
