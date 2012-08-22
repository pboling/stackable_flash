module StackableFlash
  module TestHelpers

    def flash_in_stack(slash_for_status, expecting)
      return true if slash_for_status == expecting
      if slash_for_status.kind_of?(Array)
        matches = slash_for_status.select do |to_check|
          to_check == expecting
        end
        return matches.length > 0
      end
    end

  end
end
