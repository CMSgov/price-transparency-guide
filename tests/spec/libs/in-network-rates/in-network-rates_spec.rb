require "spec_helper"
require "json"

describe "in network schema" do
  it "has a valid json schema" do
    begin
      expect{ match_response_schema("in-network-rates") }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
      expect(e.message).not_to include "AError"
    end
  end

  it "has valid JSON fee-for-service example" do
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-fee-for-service-sample.json"))

    expect(json_data).to match_response_schema("in-network-rates")
  end

  it "has valid JSON bundle example" do
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-bundle-sample.json"))

    expect(json_data).to match_response_schema("in-network-rates")
  end
end
