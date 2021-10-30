require "spec_helper"
require "json"

describe "in network schema" do
  it "validates" do
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-fee-for-service-sample.json"))

    expect(json_data).to match_response_schema("in-network-rates")
  end
end
