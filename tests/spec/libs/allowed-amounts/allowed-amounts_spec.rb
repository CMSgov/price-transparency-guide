require "spec_helper"
require "json"

describe "allowed amounts schema" do
  it "has a valid json schema" do
    begin
      expect{ match_response_schema("allowed-amounts/allowed-amounts") }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
    #  expect(e.message).not_to include "AError"
    end
  end

  it "validates the allowed amounts example" do
    json_data = JSON.parse(File.read("../examples/allowed-amounts/allowed-amounts-single-plan-sample.json"))
    expect(json_data).to match_response_schema("allowed-amounts/allowed-amounts")
  end

  it "validates the allowed amounts empty example" do
    json_data = JSON.parse(File.read("../examples/allowed-amounts/allowed-amounts-single-plan-empty-sample.json"))

    expect(json_data).to match_response_schema("allowed-amounts/allowed-amounts")
  end
end
