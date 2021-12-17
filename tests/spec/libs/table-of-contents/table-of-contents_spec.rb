require "spec_helper"
require "json"

describe "in network schema" do
  it "has a valid json schema" do
    begin
      expect{ match_response_schema("table-of-contents/table-of-contents") }.not_to raise_error
    rescue RSpec::Expectations::ExpectationNotMetError => e
      expect(e.message).not_to include "AError"
    end
  end

  it "has valid JSON table of contents example" do
    json_data = JSON.parse(File.read("../examples/table-of-contents/table-of-contents-sample.json"))

    expect(json_data).to match_response_schema("table-of-contents/table-of-contents")
  end
end
