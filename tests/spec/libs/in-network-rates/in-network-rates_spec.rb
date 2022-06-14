require "spec_helper"
require "json"

describe "in network schema" do
  it "has a valid json schema" do
    begin
      expect{ match_response_schema("in-network-rates/in-network-rates") }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
      expect(e.message).not_to include "AError"
    end
  end

  it "has valid JSON single plan fee-for-service example" do
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-fee-for-service-single-plan-sample.json"))

    expect(json_data).to match_response_schema("in-network-rates/in-network-rates")
  end

  it "has valid JSON multiple plan fee-for-service example" do
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-multiple-plans-sample.json"))

    expect(json_data).to match_response_schema("in-network-rates/in-network-rates")
  end

  it "has valid JSON bundle example" do
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-bundle-single-plan-sample.json"))

    expect(json_data).to match_response_schema("in-network-rates/in-network-rates")
  end

  it "has valid JSON no NPI example" do
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-no-npi.json"))

    expect(json_data).to match_response_schema("in-network-rates/in-network-rates")
  end
end
