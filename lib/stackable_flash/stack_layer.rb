require "stackable_flash/flash_stack"

module StackableFlash
  module StackLayer
    def self.included(base)
      base.class_eval do
        alias_method_chain :[]=, :stacking
        alias_method_chain :[], :stacking
      end
    end

    define_method "[]_with_stacking" do |key|
      if StackableFlash.stacking
        #Do it in a non-stacking block so we get normal behavior from flash[:notice] calls
        StackableFlash.not_stacked do
          actual = send("[]_without_stacking", key)
          if actual.nil?
            send("[]_with_stacking=", key, StackableFlash::FlashStack.new)
          end
        end
      else
        # All StackableFlash functionality is completely bypassed
        send("[]_without_stacking", key)
      end
      return send("[]_without_stacking", key)
    end

    define_method "[]_with_stacking=" do |key, value|
      if StackableFlash.stacking
        # Do it in a non-stacking block so we get normal behavior from flash[:notice] calls
        StackableFlash.not_stacked do
          # Make an array at the key, while providing a seamless upgrade to existing flashes
          #
          # Initial set to Array
          #
          # Principle of least surprise
          # flash[:notice] = ['message1','message2']
          # flash[:notice] # => ['message1','message2']
          #
          # Initial set to String
          #
          # Principle of least surprise
          # flash[:notice] = 'original'
          # flash[:notice] # => ['original']
          #
          # Overwrite!
          #
          # Principle of least surprise
          # flash[:notice] = 'original'
          # flash[:notice] = 'altered'
          # flash[:notice] # => ['altered']
          #
          # The same line of code does all of the above:
          self[key] = StackableFlash::FlashStack.new.replace(value.kind_of?(Array) ? value : Array(value))

          # Leave existing behavior in place, but send the full array as the value so it doesn't get killed.
          send("[]_without_stacking=", key, self[key])
        end
      else
        # All StackableFlash functionality is completely bypassed
        send("[]_without_stacking=", key, value)
      end
    end

  end
end
