require 'spec_helper'

describe StateTransition do

  it 'should have a version number' do
    StateTransition::VERSION.should_not be_nil
  end

  describe "no initialize" do
    it "should be error occured." do
      lambda{ state = StateTransition::StateMachine.new() }.should raise_error(StandardError)
    end
  end

  describe "state machine" do
    before :each do
      @sequence = []
      @state = StateTransition::StateMachine.new({
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
          after_second: -> { @sequence << "after_second" },
          after_third: -> { @sequence << "after_third" },
        }
      })
    end

    it "should @state have three(:first, :second, :third) state" do
      @state.have_state?(:first).should be_true
      @state.have_state?(:second).should be_true
      @state.have_state?(:third).should be_true
    end

    it "should @state have three('first', 'second', 'third') state" do
      @state.have_state?('first').should be_true
      @state.have_state?('second').should be_true
      @state.have_state?('third').should be_true
    end

    it "should @state have three method" do
      @state.respond_to?(:two)
      @state.respond_to?(:three)
      @state.respond_to?(:reset)
    end

    it "should show defined actions" do
      @state.define_actions.should == [:two, :three, :reset]
    end

    it "add action test" do
      @state.add_move_action(name: 'test', from: 'hoge', to: 'piyo')
      @state.have_state?(:hoge).should be_true
      @state.have_state?(:piyo).should be_true
      @state.respond_to?(:test)
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

    describe "about duplicated" do
      it "should not influence state change" do
        @copy = @state.dup
        @state.add_move_action(name: 'test', from: 'hoge', to: 'piyo')

        @copy.have_state?(:hoge).should be_false
        @copy.have_state?(:piyo).should be_false
      end
    end
  end
end
