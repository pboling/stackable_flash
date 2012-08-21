module StackableFlash
  class Railtie < Rails::Railtie

    # Only support Rails 3+?
    #ActiveSupport.on_load(:action_controller) do
    #  ActiveSupport.on_load(:after_initialize) do
    #    ActionDispatch::Flash::FlashHash.send :include, StackableFlash::StackLayer
    #  end
    #end
    config.after_initialize do
      require 'action_pack/version'
      base = if ActionPack::VERSION::MAJOR >= 3
        require 'action_dispatch'
        ActionDispatch::Flash::FlashHash
      else
        require 'action_controller'
        ActionController::Flash::FlashHash
      end
      base.send :include, StackableFlash::StackLayer
    end

  end
end
