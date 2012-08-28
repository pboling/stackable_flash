require 'spec_helper'

describe StackableFlash do
  before(:each) do
    @flash = ActionDispatch::Flash::FlashHash.new
  end

  describe "#stacking" do
    context "is true" do
      before(:each) do
        StackableFlash.stacking = true
      end
      it "should allow flashes to stack" do
        lambda {
          @flash[:error] << 'stacking'
          @flash[:error] << 'them'
          @flash[:error] << 'all'
          @flash[:error] << 'up'
        }.should_not raise_exception
        @flash[:error].should be_a_kind_of(Array)
        @flash[:error].stack.should == 'stacking<br/>them<br/>all<br/>up'
      end
    end
    context "is false" do
      before(:each) do
        StackableFlash.stacking = false
      end
      it "should not allow flashes to stack" do
        lambda { @flash[:error] << 'stacking' }.should raise_exception
        @flash[:error] = 'stacking'
        @flash[:error].should be_a_kind_of(String)
        lambda { @flash[:error].stack }.should raise_error NoMethodError
      end
    end
  end

  describe "#stacked" do
    before(:each) do
      StackableFlash.stacking = false # works in spite of this
    end
    it "should allow flashes to stack" do
      StackableFlash.stacked do
        @flash[:error] << 'stacking'
        @flash[:error] << 'them'
        @flash[:error] << 'all'
        @flash[:error] << 'up'
        @flash[:error].stack.should == 'stacking<br/>them<br/>all<br/>up' #inside block
      end
      @flash[:error].should be_a_kind_of(Array)
      @flash[:error].stack.should == ['stacking','them','all','up'] # outside block
    end
  end
  describe "#not_stacked" do
    before(:each) do
      StackableFlash.stacking = true # works in spite of this
    end
    it "should not allow flashes to stack" do
      StackableFlash.not_stacked do
        lambda { @flash[:error] << 'stacking' }.should raise_exception
        @flash[:error] = 'stacking'
      end
      @flash[:error].should be_a_kind_of(String)
      lambda { @flash[:error].stack }.should raise_error NoMethodError
    end
  end
end
