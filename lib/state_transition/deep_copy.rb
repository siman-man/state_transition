module StateTransition
  module DeepCopy
    refine Array do
      def deep_copy
        each_with_object([]) do |obj, arr|
          arr.push(( obj.is_a?(Array) )? obj.deep_copy : obj)
        end 
      end
    end

    refine Hash do
      def deep_copy
        each_with_object({}) do |(key,value), hash|
        hash[key] = ( value.is_a?(Hash) )? value.deep_copy : value
        end
      end
    end
  end
end
