require "spec_helper"
require "json"
require "pathname"
require "json_schemer"

describe "allowed amounts schema" do
  let(:schema_path) { Pathname.new("../schemas/allowed-amounts/allowed-amounts.json") }
  let(:schemer) { JSONSchemer.schema(schema_path) }

  def validate_with_errors(json_data)
    if schemer.valid?(json_data)
      true
    else
      errors = schemer.validate(json_data).to_a
      error_messages = errors.map { |e| "  - #{e['data_pointer']}: #{e['type']} (#{e['details']})" }.join("\n")
      fail "Schema validation failed:\n#{error_messages}"
    end
  end

  describe "schema validation" do
    it "has a valid json schema" do
      expect { schemer }.not_to raise_error
    end
  end

  describe "positive tests - valid examples" do
    # Automatically test all example files
    Dir.glob("../examples/allowed-amounts/*.json").each do |example_file|
      example_name = File.basename(example_file)

      it "validates example: #{example_name}" do
        json_data = JSON.parse(File.read(example_file))
        validate_with_errors(json_data)
      end
    end
  end

  describe "negative tests - invalid data" do
    let(:valid_data) { JSON.parse(File.read("../examples/allowed-amounts/allowed-amounts-single-plan-sample.json")) }

    it "rejects data missing required field: reporting_entity_name" do
      invalid_data = valid_data.dup
      invalid_data.delete("reporting_entity_name")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects data missing required field: reporting_entity_type" do
      invalid_data = valid_data.dup
      invalid_data.delete("reporting_entity_type")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects data missing required field: last_updated_on" do
      invalid_data = valid_data.dup
      invalid_data.delete("last_updated_on")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects data missing required field: version" do
      invalid_data = valid_data.dup
      invalid_data.delete("version")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects data missing required field: out_of_network" do
      invalid_data = valid_data.dup
      invalid_data.delete("out_of_network")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects uppercase plan_id_type values (should be lowercase)" do
      invalid_data = valid_data.dup
      invalid_data["plan_id_type"] = "HIOS"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid plan_id_type values" do
      invalid_data = valid_data.dup
      invalid_data["plan_id_type"] = "invalid_type"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid plan_market_type values" do
      invalid_data = valid_data.dup
      invalid_data["plan_market_type"] = "invalid_market"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid billing_class values" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"][0]["allowed_amounts"][0]["billing_class"] = "invalid_class"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid tin type values" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"][0]["allowed_amounts"][0]["tin"]["type"] = "invalid_type"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty string for required fields" do
      invalid_data = valid_data.dup
      invalid_data["reporting_entity_name"] = ""
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects negative allowed_amount" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["allowed_amount"] = -50
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects negative billed_charge" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["providers"][0]["billed_charge"] = -100
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "allows for an empty out_of_network array" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"] = []
      expect(schemer.valid?(invalid_data)).to be_truthy
    end

    it "rejects empty payments array" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"][0]["allowed_amounts"][0]["payments"] = []
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty providers array" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["providers"] = []
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty npi array" do
      invalid_data = valid_data.dup
      invalid_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["providers"][0]["npi"] = []
      expect(schemer.valid?(invalid_data)).to be_falsey
    end
  end

  describe "edge cases" do
    let(:valid_data) { JSON.parse(File.read("../examples/allowed-amounts/allowed-amounts-single-plan-sample.json")) }

    it "accepts tin type of 'npi' when SSN is used as tin" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["tin"]["type"] = "npi"
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["tin"]["value"] = "1234567890"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts multiple billing_code_modifiers" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["billing_code_modifier"] = ["AS", "59"]
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts multiple NPIs in providers array" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["providers"][0]["npi"] = [1111111111, 2222222222, 3333333333]
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts service_code array with multiple codes" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["service_code"] = ["11", "12", "21"]
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts allowed_amount of zero" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["allowed_amount"] = 0
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts billed_charge of zero" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["providers"][0]["billed_charge"] = 0
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts decimal values for allowed_amount" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["allowed_amount"] = 123.45
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts decimal values for billed_charge" do
      edge_case_data = valid_data.dup
      edge_case_data["out_of_network"][0]["allowed_amounts"][0]["payments"][0]["providers"][0]["billed_charge"] = 567.89
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end
  end
end
