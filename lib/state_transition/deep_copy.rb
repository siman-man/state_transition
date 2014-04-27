module StateTransition
  module DeepCopy
    if RUBY_VERSION >= "2.1.0"
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
    else
      class Array
        def deep_copy
          each_with_object([]) do |obj, arr|
            arr.push(( obj.is_a?(Array) )? obj.deep_copy : obj)
          end 
        end
      end

      class Hash
        def deep_copy
          each_with_object({}) do |(key,value), hash|
            hash[key] = ( value.is_a?(Hash) )? value.deep_copy : value
          end
        end
      end
    end
  end
end
