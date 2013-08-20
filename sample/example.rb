require 'state_transition'

state = StateTransition::StateMachine.new({
  initial: :first,

  actions: [
    { name: "move_first", from: [ :second, :third ], to: :first },
    { name: "move_second", from: [ :first, :third ], to: :second },
    { name: "move_third", from: :second, to: :third },
  ],

  callbacks: {
    before_second: -> { puts "before_second" },
    after_second: -> { puts "after_second" },
  }
})

puts state.current            #=> :first
puts state.can_move?(:second) #=> true
puts state.can_move?(:third)  #=> false

state.move_second           

puts state.current            #=> :second
