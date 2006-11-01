module Spec
  module Mocks
    module MockMethods
      def should_receive(sym, &block)
        __mock_handler.add_message_expectation caller(1)[0], sym, &block
      end
      
      def received_message?(sym, *args, &block)
        __mock_handler.received_message?(sym, *args, &block)
      end

      def should_not_receive(sym, &block)
        __mock_handler.add_negative_message_expectation caller(1)[0], sym, &block
      end
      
      def stub!(sym)
        __mock_handler.add_stub caller(1)[0], sym
      end
      
      def __verify
        __mock_handler.verify
      end

      def __reset_mock
        __mock_handler.reset
      end

      def method_missing(sym, *args, &block)
        __mock_handler.instance_eval {@messages_received << [sym, args, block]}
        begin
          return self if __mock_handler.null_object?
          super(sym, *args, &block)
        rescue NoMethodError
          __mock_handler.raise_unexpected_message_error sym, *args
        end
      end
      
      private
      def __mock_handler
        @mock_handler ||= MockHandler.new(self, @name, @options)
      end
    end
  end
end