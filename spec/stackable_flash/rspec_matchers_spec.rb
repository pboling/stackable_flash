require 'spec_helper'

describe StackableFlash::RspecMatchers do
  before(:each) do
    @flash = ActionDispatch::Flash::FlashHash.new
  end
  describe "tests against strange things" do
    context "should" do
      it "should raise error when not a match" do
        lambda {@flash[:notice].should have_stackable_flash(1)}.should raise_error RSpec::Expectations::ExpectationNotMetError
        lambda {@flash[:notice].should have_stackable_flash({:hello => 'asdf'})}.should raise_error RSpec::Expectations::ExpectationNotMetError
      end
      it "should not raise an error when a match" do
        lambda { @flash[:notice] = 1
          @flash[:notice].should have_stackable_flash(1)}.should_not raise_exception
        lambda { @flash[:notice] = {:hello => 'asdf'}
          @flash[:notice].should have_stackable_flash({:hello => 'asdf'})}.should_not raise_exception
      end
    end
    context "should_not" do
      it "should raise error when not a match" do
        lambda {@flash[:notice].should_not have_stackable_flash(1)}.should_not raise_exception
        lambda {@flash[:notice].should_not have_stackable_flash({:hello => 'asdf'})}.should_not raise_exception
      end
      it "should not raise an error when a match" do
        lambda { @flash[:notice] = 1
          @flash[:notice].should_not have_stackable_flash(1)}.should raise_error RSpec::Expectations::ExpectationNotMetError
        lambda { @flash[:notice] = {:hello => 'asdf'}
          @flash[:notice].should_not have_stackable_flash({:hello => 'asdf'})}.should raise_error RSpec::Expectations::ExpectationNotMetError
      end
    end
  end

  describe "have_stackable_flash after using :[]=" do
    context "a string" do
      context "when there is not an existing flash message" do
        context "sets the flash message" do
          before(:each) do
            @flash[:notice] = 'message'
          end
          it "should match the value itself" do
            @flash[:notice].should have_stackable_flash('message')
          end
          it "should match the entire array" do
            @flash[:notice].should have_stackable_flash(['message'])
          end
        end
      end
      context "when there is an existing flash message" do
        context "overwrite the original string" do
          before(:each) do
            @flash[:notice] = 'original'
            @flash[:notice] = ''
          end
          it "should match the value itself" do
            @flash[:notice].should have_stackable_flash('')
          end
          it "should match the entire array" do
            @flash[:notice].should have_stackable_flash([''])
          end
        end
        context "overwrite the original array" do
          before(:each) do
            @flash[:notice] = ['original']
            @flash[:notice] = ''
          end
          it "should match the value itself" do
            @flash[:notice].should_not have_stackable_flash('original')
            @flash[:notice].should_not have_stackable_flash(['original'])
            @flash[:notice].should have_stackable_flash('')
          end
          it "should match the entire array" do
            @flash[:notice].should have_stackable_flash([''])
          end
        end
      end
    end
    context "an array" do
      context "when there is not an existing flash message" do
        context "sets the flash message" do
          before(:each) do
            @flash[:notice] = ['message']
          end
          it "should match the value itself" do
            @flash[:notice].should have_stackable_flash('message')
          end
          it "should match the entire array" do
            @flash[:notice].should have_stackable_flash(['message'])
          end
        end
      end
      context "when there is an existing flash message" do
        context "overwrite the original string" do
          before(:each) do
            @flash[:notice] = 'original'
            @flash[:notice] = ['message']
          end
          it "should match the value itself" do
            @flash[:notice].should_not have_stackable_flash('original')
            @flash[:notice].should have_stackable_flash('message')
          end
          it "should match the entire array" do
            @flash[:notice].should have_stackable_flash(['message'])
          end
        end
        context "overwrite the original array" do
          before(:each) do
            @flash[:notice] = ['original']
            @flash[:notice] = ['message']
          end
          it "should match the value itself" do
            @flash[:notice].should_not have_stackable_flash(['original'])
            @flash[:notice].should_not have_stackable_flash('original')
            @flash[:notice].should have_stackable_flash('message')
          end
          it "should match the entire array" do
            @flash[:notice].should have_stackable_flash(['message'])
          end
        end
      end
    end
  end
  # Actually testing how it interacts with Array's :<< method
  describe "have_stackable_flash after using :<<" do
    context "a string" do
      context "should build a stack" do
        before(:each) do
          @flash[:notice] = 'original'
          @flash[:notice] << 'message'
        end
        it "should match the value itself" do
          @flash[:notice].should have_stackable_flash('original')
          @flash[:notice].should have_stackable_flash('message')
        end
        it "should match the entire array" do
          @flash[:notice].should have_stackable_flash(['original','message'])
        end
      end
    end
    context "an array" do
      context "should build a stack" do
        before(:each) do
          @flash[:notice] = ['original']
          @flash[:notice] << 'message'
        end
        it "should match the value itself" do
          @flash[:notice].should_not have_stackable_flash(['original'])
          @flash[:notice].should have_stackable_flash('original')
          @flash[:notice].should have_stackable_flash('message')
        end
        it "should match the entire array" do
          @flash[:notice].should have_stackable_flash(['original','message'])
        end
      end
      context "should allow any data type" do
        before(:each) do
          @flash[:notice] = ['original']
          @flash[:notice] << ['nested']
          @flash[:notice] << 123
        end
        it "should match the value itself" do
          @flash[:notice].should have_stackable_flash('original')
          @flash[:notice].should_not have_stackable_flash(['original'])
          @flash[:notice].should have_stackable_flash(['nested'])
          @flash[:notice].should_not have_stackable_flash('nested')
          @flash[:notice].should have_stackable_flash(123)
        end
        it "should match the entire array" do
          @flash[:notice].should have_stackable_flash(['original',['nested'],123])
        end
      end
    end
  end

  describe "mixed use" do
    context "when StackableFlash is turned off and on" do
      it "should not fail for strings" do
        StackableFlash.stacking = false
        @flash[:notice] = 'original'
        StackableFlash.stacking = true
        @flash[:notice] << 'message'
        @flash[:notice].should have_stackable_flash('originalmessage')
      end
      it "should not fail for an array" do
        StackableFlash.stacking = false
        @flash[:notice] = ['original']
        StackableFlash.stacking = true
        @flash[:notice] << 'message'
        @flash[:notice].should have_stackable_flash('original')
        @flash[:notice].should have_stackable_flash('message')
        @flash[:notice].should have_stackable_flash(['original','message'])
      end
    end
    context "when StackableFlash is turned on and off" do
      it "should not fail for strings" do
        StackableFlash.stacking = true
        @flash[:notice] = 'original'
        StackableFlash.stacking = false
        @flash[:notice] << 'message'
        @flash[:notice].should have_stackable_flash('original')
        @flash[:notice].should have_stackable_flash('message')
        @flash[:notice].should have_stackable_flash(['original','message'])
      end
    end
  end

  describe "when stackable_flash is off" do
    context "StackableFlash.not_stacked" do
      it "should not fail for strings" do
        StackableFlash.not_stacked do
          @flash[:notice] = 'original'
          @flash[:notice] << 'message'
          @flash[:notice].should have_stackable_flash('originalmessage')
          @flash[:notice].should_not have_stackable_flash('original')
          @flash[:notice].should_not have_stackable_flash('message')
          @flash[:notice].should_not have_stackable_flash(['original','message'])
        end
      end
    end

  end
end
