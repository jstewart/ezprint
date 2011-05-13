module Ezprint
  module Processors
    class Base
      def self.process(html_string, options = {})
        raise RuntimeError.new "Process is not implemented"
      end
    end
  end
end
