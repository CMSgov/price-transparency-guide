require "spec_helper"
require "json"
require "pathname"
require "json_schemer"

describe "in network schema" do
  it "has a valid json schema" do
    begin
      schema_path = Pathname.new("../schemas/table-of-contents/table-of-contents.json")
      expect{ JSONSchemer.schema(schema_path) }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
      expect(e.message).not_to include "AError"
    end
  end

  it "has valid JSON table of contents example" do
    schema_path = schema_path = Pathname.new("../schemas/table-of-contents/table-of-contents.json")
    schemer = JSONSchemer.schema(schema_path)
    json_data = JSON.parse(File.read("../examples/table-of-contents/table-of-contents-sample.json"))
    expect(schemer.valid?(json_data)).to be_truthy
  end
end
