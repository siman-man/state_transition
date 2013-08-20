# StateTransition

https://github.com/jakesgordon/javascript-state-machine
これが便利だったのでRuby verを作ってみた。

## Installation

Add this line to your application's Gemfile:

    gem 'state_transition'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install state_transition

## Usage

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
