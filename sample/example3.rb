require 'state_transition'

state = StateTransition::StateMachine.new(
  initial: :hello,
  actions: [
    { name: 'test', from: :hello, to: :world }
  ]
)

hoge = StateTransition::StateMachine.new(
  initial: :hello,
  actions: [
    { name: 'hoge', from: :piyo, to: :hello },
    { name: 'piyo', from: :piyo, to: :hello },
    { name: 'test', from: :hello, to: :piyo }
  ]
)

p state.current
p state.can_move?(:piyo)
p hoge.can_move?(:piyo)
p state.define_actions
p hoge.define_actions

state.add_move_action(name: :world, from: :world, to: :hello)
p state.define_actions
