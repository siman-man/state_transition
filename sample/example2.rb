require 'state_transition'

class HelloWorld
  attr_reader :state

  def initialize
    @hello = "Hello World!"

    @state = StateTransition::StateMachine.new({
      initial: 'first',

      actions: [
        { name: 'one',  from: 'first', to: 'second' },
        { name: 'two',  from: 'second', to: 'third' },
        { name: 'three', from: 'third', to: 'first' },
        { name: 'reset', from: ['first', 'second', 'thrid'], to: 'first' }
      ],

      callbacks: {
        before_first: -> { say_world },
        before_second: -> { say_hello },
        before_third: -> { say_hello_world },
      }
    })
  end

  def say_hello
    puts "hello"
  end

  def say_hello_world
    puts @hello
  end

  def say_world
    puts "world"
  end
end

h = HelloWorld.new

p h.state.current
h.state.one
h.state.two
h.state.three
