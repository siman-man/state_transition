require "state_transition/version"

module StateTransition
  class StateMachine
    attr_reader :current, :define_actions
    attr_accessor :state_list

    def initialize(data = nil)
      @state_list = []
      @state_graph = Hash.new{|hash, key| hash[key] = []}
      @callbacks = {}
      @define_actions = []

      begin
        @current = data[:initial] 
      rescue 
        raise StandardError, "StateMachine: Not define first state."
      end

      set_state(data[:initial])

      create_move_action(data[:actions] || [])
      create_callbacks(data[:callbacks] || [])
    end

    def initialize_copy(org)
      @callbacks = @callbacks.dup
      @state_list = @state_list.dup
      @state_graph = @state_graph.dup
      @define_actions = @define_actions.dup
    end

    def have_state?(state)
      @state_list.include?(state.to_sym)
    end

    def add_action(action)
      create_move_action([action])
    end

    def create_move_action(actions)
      actions.each do |action|
        name = action[:name].to_sym
        from = action[:from]
          to = action[:to].to_sym

        @define_actions << name.to_sym

        set_state(from)
        set_state(to)
        create_edge(from, to)

        StateMachine.class_eval do
          define_method name do
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

    def create_callbacks(callbacks)
      callbacks.each do |name, function|
        @callbacks[name] = function
      end
    end

    def can_move?(state)
      @state_graph[@current].include?(state)
    end

    def set_state(state)
      @state_list.push state.to_sym unless !state.respond_to?(:to_sym) || have_state?(state)
    end

    def create_edge(from, to)
      if from.kind_of?(Array) 
        from.each do |state|
          state = state.to_sym
          @state_graph[state].push to unless @state_graph[state].include?(to)
        end
      else
        @state_graph[from].push to
      end
    end
  end
end
