module StackableFlash
  class FlashStack < Array

    # TODO: Add smart filters for flashes, like 'sticky' via method_missing.

    # Handle the following use case:
    #   flash[:notice] = 'First Part'
    #   flash[:notice] += ' Second Part'
    # => ['First Part Second Part']

    def +(to_add)
      if StackableFlash.stacking

        if to_add.kind_of?(Array)
          super(to_add)
        else

          # Make sure it responds to +, otherwise just push it onto the stack
          if self.last.respond_to?(:+)
            self[self.length - 1] = self.last + to_add
          else
            self << to_add
          end
        end

      else
        super(to_add)
      end
    end

    def stack
      if StackableFlash.stacking
        # Format the stacked flashes according to stack_with_proc lambda
        StackableFlash::Config.config[:stack_with_proc].call(self)
      else
        # All StackableFlash functionality is completely bypassed
        self
      end
    end

  end
end
