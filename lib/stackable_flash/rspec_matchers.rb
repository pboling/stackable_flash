require 'stackable_flash/test_helpers'

module StackableFlash
  module RspecMatchers
    include StackableFlash::TestHelpers
    RSpec::Matchers.define :have_stackable_flash do |expecting|
      define_method :has_stackable_flash? do |slash|
        flash_in_stack(slash, expecting)
      end

      match{|slash| has_stackable_flash?(slash)}

      failure_message_for_should do |slash|
        "expected flash to be or include #{expected.inspect}, but got #{slash}"
      end
      failure_message_for_should_not do |slash|
        "expected flash to not be and not include #{expected.inspect}, but got #{slash}"
      end
    end
  end
end
