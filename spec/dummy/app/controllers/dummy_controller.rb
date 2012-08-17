class DummyController < ApplicationController
  include StackableFlash
  def override
    flash[:notice] = 'original'
    flash[:notice] = 'message'
  end

  def stack
    flash[:notice] = 'original'
    flash[:notice] << 'message'
    flash[:notice] << 'another'
  end

end
