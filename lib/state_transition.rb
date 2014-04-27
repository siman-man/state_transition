require "state_transition/version"
require "state_transition/deep_copy"

module StateTransition
  class StateMachine
    if RUBY_VERSION >= "2.1.0"
      using DeepCopy
    end

    attr_reader :current, :define_actions

    def initialize(data = nil)
      @state_list = Hash.new{|hash, key| hash[key] = {}}
      @callbacks = {}
      @define_actions = []

      begin
        @current = data[:initial] 
      rescue 
        raise StandardError, "StateMachine: Not define first state."
      end

      @current = data[:initial]

      create_move_action(data[:actions] || [])
      create_callbacks(data[:callbacks] || [])
    end

    def initialize_copy(org)
      @callbacks = @callbacks.deep_copy
      @state_list = @state_list.deep_copy
      @define_actions = @define_actions.deep_copy
    end

    def have_state?(state)
      @state_list.keys.include?(state.to_sym)
    end

    def add_move_action(action)
      create_move_action([action])
    end

    def create_move_action(actions)
      actions.each do |action|
        key = action[:name].to_sym
        froms = ( action[:from].is_a?(Array) )? action[:from] : [action[:from]]
        to = action[:to].to_sym

        @define_actions << key.to_sym

        set_state(froms: froms, key: key, to: to)

        StateMachine.class_eval do
          froms.each do |from|
            define_method key do
              if can_move?(to)
                before_func = ("before_" + to.to_s).to_sym
                after_func  = ("after_" + to.to_s).to_sym

                @callbacks[before_func].call if @callbacks[before_func] 
                @current = to
                @callbacks[after_func].call if @callbacks[after_func]
              else
                raise StandardError, "Can not move from '#{@current}' to '#{to}'!"
              end
            end
          end
        end
      end
    end

    def create_callbacks(callbacks)
      callbacks.each do |name, function|
        @callbacks[name] = function
      end
    end

    def can_move?(point, from: @current, to: nil)
      @state_list[from].values.include?(to||point)
    end

    def set_state(froms:, key:, to:)
      froms = [froms] unless froms.is_a?(Array)

      froms.each do |from|
        @state_list[to] = {} unless @state_list.has_key?(to)
        @state_list[from.to_sym][key] = to
      end
    end
  end
end
