require "state_transition/version"

module StateTransition
  class StateMachine
    attr_reader :current
    attr_accessor :state_list

    def initialize(data = nil)
      @state_list = []
      @state_graph = Hash.new{|hash, key| hash[key] = []}
      @callbacks = {}
      @sequence = 3

      begin
        @current = data[:initial] 
      rescue 
        raise StandardError, "StateMachine: Not define first state."
      end

      set_state(data[:initial])

      create_move_action(data[:actions])
      create_callbacks(data[:callbacks])
    end

    def have_state?(state)
      @state_list.include?(state)
    end

    def create_move_action(actions = [])
      actions.each do |action|
        name = action[:name]
        from = action[:from]
          to = action[:to]

        set_state(from)
        set_state(to)
        create_edge(from, to)

        StateMachine.class_eval do
          define_method name do
            if can_move?(to)
              before_func = ("before_" + to.to_s).to_sym
              after_func  = ("after_" + to.to_s).to_sym
              if @callbacks[before_func] 
                @callbacks[before_func].call
              end
              @current = to
              @callbacks[after_func].call if @callbacks[after_func]
            else
              raise StandardError, "Can not move from '#{@current}' to '#{to}'!"
            end
          end
        end
      end
    end

    def create_callbacks(callbacks = [])
      callbacks.each do |name, function|
        @callbacks[name] = function
      end
    end

    def can_move?(state)
      @state_graph[@current].include?(state)
    end

    def set_state(state)
      @state_list.push state unless have_state?(state) || !state.kind_of?(Symbol)
    end

    def create_edge(from, to)
      if from.kind_of?(Array) 
        from.each do |state|
          @state_graph[state].push to unless @state_graph[state].include?(to)
        end
      else
        @state_graph[from].push to
      end
    end
  end
end
