require 'spec_helper'

describe DummyController do

  render_views

  it "should handle multiple keys" do
    get :multiple_keys
    controller.flash[:notice].should == ['This is a Notice']
    #controller.flash[:errors].should == ['This is an Error']
  end

  it "should override" do
    get :override
    controller.flash[:notice].should_not == ['original']
    controller.flash[:notice].should == ['message']
  end

  it "should stack" do
    get :stack
    controller.flash[:notice].should == ['original','message','another']
    controller.flash[:notice].stack.should == 'original<br/>message<br/>another'
  end

  it "should cold boot" do
    get :cold_boot
    controller.flash[:notice].should == ['original','message','another']
    controller.flash[:notice].stack.should == 'original<br/>message<br/>another'
  end

end

