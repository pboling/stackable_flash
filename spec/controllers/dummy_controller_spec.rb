require 'spec_helper'

describe DummyController do

  render_views

  it "should override" do
    get :override
    controller.flash[:notice].should == ['message']
  end

  it "should build a stack" do
    get :stack
    controller.flash[:notice].should == ['original','message','another']
  end

  it "should allow transformation" do
    get :stack
    controller.flash[:notice].stack.should == 'original<br/>message<br/>another'
  end

end

