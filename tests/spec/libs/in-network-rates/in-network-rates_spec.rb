require "spec_helper"
require "json"
require "pathname"
require "json_schemer"

describe "in network schema" do
  it "has a valid json schema" do
    begin
      schema_path = Pathname.new("../schemas/in-network-rates/in-network-rates.json")
      expect{ JSONSchemer.schema(schema_path) }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
      expect(e.message).not_to include "AError"
    end
  end

  it "has valid JSON single plan fee-for-service example" do
    schema_path = schema_path = Pathname.new("../schemas/in-network-rates/in-network-rates.json")
    schemer = JSONSchemer.schema(schema_path)
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-fee-for-service-single-plan-sample.json"))
    expect(schemer.valid?(json_data)).to be_truthy
  end

  it "has valid JSON multiple plan fee-for-service example" do
    schema_path = schema_path = Pathname.new("../schemas/in-network-rates/in-network-rates.json")
    schemer = JSONSchemer.schema(schema_path)
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-multiple-plans-sample.json"))
    expect(schemer.valid?(json_data)).to be_truthy
  end

  it "has valid JSON bundle example" do
    schema_path = schema_path = Pathname.new("../schemas/in-network-rates/in-network-rates.json")
    schemer = JSONSchemer.schema(schema_path)
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-bundle-single-plan-sample.json"))
    expect(schemer.valid?(json_data)).to be_truthy
  end

  it "has valid JSON no NPI example" do
    schema_path = schema_path = Pathname.new("../schemas/in-network-rates/in-network-rates.json")
    schemer = JSONSchemer.schema(schema_path)
    json_data = JSON.parse(File.read("../examples/in-network-rates/in-network-rates-no-npi.json"))
    expect(schemer.valid?(json_data)).to be_truthy
  end
end
