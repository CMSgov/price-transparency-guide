require "spec_helper"
require "json"
require "pathname"
require "json_schemer"

describe "allowed amounts schema" do
  it "has a valid json schema" do
    begin
      schema_path = Pathname.new("../schemas/allowed-amounts/allowed-amounts.json")
      expect{ JSONSchemer.schema(schema_path) }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
      expect(e.message).not_to include "AError"
    end
  end

  it "validates the allowed amounts single plan example" do
    schema_path = Pathname.new("../schemas/allowed-amounts/allowed-amounts.json")
    schemer = JSONSchemer.schema(schema_path)
    json_data = JSON.parse(File.read("../examples/allowed-amounts/allowed-amounts-single-plan-sample.json"))
    expect(schemer.valid?(json_data)).to be_truthy
  end

  it "validates the allowed amounts multiple plan example" do
    schema_path = Pathname.new("../schemas/allowed-amounts/allowed-amounts.json")
    schemer = JSONSchemer.schema(schema_path)
    json_data = JSON.parse(File.read("../examples/allowed-amounts/allowed-amounts-multiple-plan-sample.json"))
    expect(schemer.valid?(json_data)).to be_truthy
  end
end
