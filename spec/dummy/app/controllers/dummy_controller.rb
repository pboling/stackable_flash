class DummyController < ApplicationController

  def multiple_keys
    flash[:notice] = 'This is a Notice'
    flash[:errors] = 'This is an Error'
    render :text => 'Foo'
  end

  def override
    flash[:notice] = 'original'
    flash[:notice] = 'message'
    render :text => 'Foo'
  end

  def stack
    flash[:notice] = 'original'
    flash[:notice] << 'message'
    flash[:notice] << 'another'
    render :text => 'Foo'
  end

  def cold_boot
    flash[:notice] << 'original'
    flash[:notice] << 'message'
    flash[:notice] << 'another'
    render :text => 'Foo'
  end

end
