require "spec_helper"
require "json"

describe "in network schema" do
  it "has a valid json schema" do
    begin
      expect{ match_response_schema("provider-reference/provider-reference") }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
      expect(e.message).not_to include "AError"
    end
  end

  it "has valid JSON table of contents example" do
    json_data = JSON.parse(File.read("../examples/provider-reference/provider-reference.json"))

    expect(json_data).to match_response_schema("provider-reference/provider-reference")
  end
end
