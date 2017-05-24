require "stackable_flash/flash_stack"

module StackableFlash
  module StackLayer

    def [](key)
      if StackableFlash.stacking
        #Do it in a non-stacking block so we get normal behavior from flash[:notice] calls
        StackableFlash.not_stacked do
          actual = super(key)
          if actual.nil?
            send(:[]=, key, StackableFlash::FlashStack.new)
          end
        end
      else
        # All StackableFlash functionality is completely bypassed
        super(key)
      end
      return super(key)
    end

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
    # The same line of code does all of the above.
    # Leave existing behavior in place, but send the full array as the value so it doesn't get killed.
    def []=(key, value)
      if StackableFlash.stacking
        super(key,
          StackableFlash::FlashStack.new.replace(
            value.kind_of?(Array) ?
              value :
              # Preserves nil values in the result... I suppose that's OK, users can compact if needed :)
              Array.new(1, value)
          )
        )
      else
        # All StackableFlash functionality is completely bypassed
        super(key, value)
      end
    end

  end
end
