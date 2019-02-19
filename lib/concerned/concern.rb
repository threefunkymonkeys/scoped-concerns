module Scoped
  module Concern
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module ClassMethods
      def run(params = {})
        instance = new(params)
        instance.run
      end
    end

    module InstanceMethods
      def success(results = {})
        Response.new(result: results)
      end

      def error(errors = {})
        Response.new(errors: errors)
      end
    end
  end
end
