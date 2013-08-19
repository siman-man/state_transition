require 'spec_helper'

describe StateTransition do
  it 'should have a version number' do
    StateTransition::VERSION.should_not be_nil
  end

  describe "init state" do
    before :all do
      @sequence = []
      @state = StateTransition::StateTransition.new({
        initial: :first,

        actions: [
          { name: 'two', from: :first, to: :second },
          { name: 'three', from: :second, to: :third },
          { name: 'reset', from: [:first, :second, :third], to: :first }
        ],

        callbacks: {
          before_first: -> { @sequence << "before_first" },
          before_second: -> { @sequence << "before_second" },
          before_third: -> { @sequence << "before_third" },
          after_first: -> { @sequence << "after_first" },
          after_second: -> { @sequence << "after_second"; puts "Hello World!" },
          after_third: -> { @sequence << "after_third" },
        }
      })
    end

    it "should @state have three(:first, :second, :third) state" do
      @state.have_state?(:first).should be_true
      @state.have_state?(:second).should be_true
      @state.have_state?(:third).should be_true
    end

    it "should first state is :first" do
      @state.current.should == :first
    end

    describe "test for callbacks" do
      before :each do 
        @state.reset
      end

      it "check callback when move second." do
        @sequence.clear
        @state.two

        @sequence[0].should == "before_second"
        @sequence[1].should == "after_second"
      end
    end

    describe "about move state" do
      before :each do
        @state.reset
      end

      it "should be 'two' action after state 'second'" do
        @state.two
        @state.current.should == :second
      end

      it "should be :first state after 'reset' action." do
        @state.two
        @state.reset
        @state.current.should == :first
      end

      it "should be can move from 'first' to 'second'" do
        @state.can_move?(:second).should be_true
      end

      it "should be cannot move from 'first' to 'third'" do
        @state.can_move?(:third).should be_false
      end

      it "should be raised error invalid action" do
        lambda{ @state.three }.should raise_error(StandardError)
      end
    end
  end
end
