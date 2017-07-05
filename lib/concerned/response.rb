module Concerned
  class InvalidType < RuntimeError;end

  class Response
    attr_accessor :result, :errors

    def initialize(result: {}, errors: {})
      raise InvalidType, "result must be a hash" unless result.is_a?(Hash)
      raise InvalidType, "errors must be a hash" unless errors.is_a?(Hash)

      @result = result
      @errors = errors
    end

    def success?
      @errors.empty?
    end
  end
end
