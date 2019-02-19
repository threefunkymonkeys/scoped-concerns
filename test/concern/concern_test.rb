require_relative '../test_helper'

class MyConcern
  include Scoped::Concern
end

describe Scoped::Concern do
  it "should add class run method" do
    assert MyConcern.respond_to?(:run)
  end

  it "should add instance success and error methods" do
    concern = MyConcern.new

    assert concern.respond_to?(:success)
    assert concern.respond_to?(:error)
  end

  it "should return a Response instance with no errors" do
    concern = MyConcern.new
    result = { message: "Done" }

    response = concern.success(result)

    assert response.is_a?(Scoped::Response)
    assert response.errors.empty?

    assert_equal result, response.result
  end
end
