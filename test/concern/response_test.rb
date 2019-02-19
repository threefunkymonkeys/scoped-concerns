require_relative '../test_helper'

describe Scoped::Response do
  it "should expose result and errors" do
    response = Scoped::Response.new

    assert response.respond_to?(:result)
    assert response.respond_to?(:errors)
  end

  it "should not accept other than a Hash for result" do
    assert_raises(Scoped::InvalidType, "result must be a Hash") do
      Scoped::Response.new(result: "Hallo")
    end
  end

  it "should not accept other than a Hash for errors" do
    assert_raises(Scoped::InvalidType, "result must be a Hash") do
      Scoped::Response.new(errors: "Hallo")
    end
  end

  it "should be successful if no errors" do
    response = Scoped::Response.new(result: { message: "I'm successful" })
    assert response.success?
  end

  it "should not be successful if errors" do
    response = Scoped::Response.new(result: { message: "I'm successful" },
                                       errors: { success: "No, you're not" })

    assert !response.success?
  end
end
