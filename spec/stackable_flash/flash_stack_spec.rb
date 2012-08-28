require 'spec_helper'

describe StackableFlash::StackLayer do
  before(:each) do
    @flash = ActionDispatch::Flash::FlashHash.new
  end

  describe ":[]=" do
    context "a string" do
      context "when there is not an existing flash message" do
        it "sets the flash message" do
          @flash[:notice] = 'message'
          @flash[:notice].should == ['message']
          @flash[:notice].should be_a(StackableFlash::FlashStack)
        end
      end
      context "when there is an existing flash message" do
        it "overwrite the original string" do
          @flash[:notice] = 'original'
          @flash[:notice] = ''
          @flash[:notice].should == ['']
          @flash[:notice].should be_a(StackableFlash::FlashStack)
        end
        it "overwrite the original array" do
          @flash[:notice] = ['original']
          @flash[:notice] = ''
          @flash[:notice].should == ['']
          @flash[:notice].should be_a(StackableFlash::FlashStack)
        end
      end
    end
    context "an array" do
      context "when there is not an existing flash message" do
        it "sets the flash message" do
          @flash[:notice] = ['message']
          @flash[:notice].should == ['message']
          @flash[:notice].should be_a(StackableFlash::FlashStack)
        end
      end
      context "when there is an existing flash message" do
        it "overwrite the original string" do
          @flash[:notice] = 'original'
          @flash[:notice] = ['message']
          @flash[:notice].should == ['message']
          @flash[:notice].should be_a(StackableFlash::FlashStack)
        end
        it "overwrite the original array" do
          @flash[:notice] = ['original']
          @flash[:notice] = ['message']
          @flash[:notice].should == ['message']
          @flash[:notice].should be_a(StackableFlash::FlashStack)
        end
      end
    end
  end
  # Actually testing how it interacts with Array's :<< method
  describe ":<<" do
    context "a string" do
      it "should build a stack" do
        @flash[:notice] = 'original'
        @flash[:notice] << 'message'
        @flash[:notice].should == ['original','message']
        @flash[:notice].should be_a(StackableFlash::FlashStack)
      end
    end
    context "an array" do
      it "should build a stack" do
        @flash[:notice] = ['original']
        @flash[:notice] << 'message'
        @flash[:notice].should == ['original','message']
        @flash[:notice].should be_a(StackableFlash::FlashStack)
      end
      it "should allow any data type" do
        @flash[:notice] = ['original']
        @flash[:notice] << ['nested']
        @flash[:notice] << 123
        @flash[:notice].should == ['original',['nested'],123]
        @flash[:notice].should be_a(StackableFlash::FlashStack)
      end
    end
  end
  describe "#stack" do
    context "when there is an existing flash message" do
      it "returns the result of calling the lambda in config[:stack_with_proc]" do
        @flash[:notice] = 'message'
        @flash[:notice].should == ['message']
        @flash[:notice].stack.should == 'message'
        @flash[:notice].stack.should == StackableFlash::Config.config[:stack_with_proc].call(@flash[:notice])
      end
    end
  end

  describe "mixed use" do
    it "should not fail when StackableFlash is turned off and on, unless calling #stack" do
      StackableFlash.stacking = false
      @flash[:notice] = 'original'
      StackableFlash.stacking = true
      @flash[:notice] << 'message'
      @flash[:notice].should == 'originalmessage'
      lambda { @flash[:notice].stack }.should raise_error(NoMethodError)
    end
    it "should not fail when StackableFlash is turned on and off" do
      StackableFlash.stacking = true
      @flash[:notice] = 'original'
      StackableFlash.stacking = false
      @flash[:notice] << 'message'
      @flash[:notice].should == ['original','message']
      @flash[:notice].stack.should == ['original','message']
    end

  end

end
