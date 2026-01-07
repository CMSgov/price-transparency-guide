require "spec_helper"
require "json"
require "pathname"
require "json_schemer"

describe "in network schema" do
  let(:schema_path) { Pathname.new("../schemas/in-network-rates/in-network-rates.json") }
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
    Dir.glob("../examples/in-network-rates/*.json").each do |example_file|
      example_name = File.basename(example_file)

      it "validates example: #{example_name}" do
        json_data = JSON.parse(File.read(example_file))
        validate_with_errors(json_data)
      end
    end
  end

  describe "negative tests - invalid data" do
    let(:valid_data) { JSON.parse(File.read("../examples/in-network-rates/in-network-rates-fee-for-service-single-plan-sample.json")) }

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

    it "rejects uppercase plan_id_type values (should be lowercase)" do
      invalid_data = valid_data.dup
      invalid_data["plan_id_type"] = "EIN"
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

    it "rejects invalid negotiation_arrangement values" do
      invalid_data = valid_data.dup
      invalid_data["in_network"][0]["negotiation_arrangement"] = "invalid_arrangement"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid negotiated_type values" do
      invalid_data = valid_data.dup
      invalid_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_type"] = "invalid_type"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid billing_class values" do
      invalid_data = valid_data.dup
      invalid_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["billing_class"] = "invalid_class"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid setting values" do
      invalid_data = valid_data.dup
      invalid_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["setting"] = "invalid_setting"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty string for required fields" do
      invalid_data = valid_data.dup
      invalid_data["reporting_entity_name"] = ""
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects negative negotiated_rate" do
      invalid_data = valid_data.dup
      invalid_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_rate"] = -100
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty in_network array" do
      invalid_data = valid_data.dup
      invalid_data["in_network"] = []
      expect(schemer.valid?(invalid_data)).to be_falsey
    end
  end

  describe "edge cases" do
    let(:valid_data) { JSON.parse(File.read("../examples/in-network-rates/in-network-rates-fee-for-service-single-plan-sample.json")) }

    it "accepts evergreen contract expiration date (9999-12-31)" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["expiration_date"] = "9999-12-31"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts CSTM-00 service code for all service codes" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["service_code"] = ["CSTM-00"]
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts CSTM-00 billing code for all billing codes" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["billing_code"] = "CSTM-00"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts CSTM-ALL billing_code_type for all code types" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["billing_code_type"] = "CSTM-ALL"
      edge_case_data["in_network"][0]["billing_code"] = "CSTM-00"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts tin type of 'npi' when SSN is used as tin" do
      edge_case_data = valid_data.dup
      edge_case_data["provider_references"][0]["provider_groups"][0]["tin"]["type"] = "npi"
      edge_case_data["provider_references"][0]["provider_groups"][0]["tin"]["value"] = "1234567890"
      edge_case_data["provider_references"][0]["provider_groups"][0]["tin"].delete("business_name")
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts percentage negotiated_type with decimal values" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_type"] = "percentage"
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_rate"] = 65.5
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts per diem negotiated_type" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_type"] = "per diem"
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_rate"] = 5500.00
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts derived negotiated_type" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_type"] = "derived"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts fee schedule negotiated_type" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["negotiated_type"] = "fee schedule"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts multiple billing_code_modifiers" do
      edge_case_data = valid_data.dup
      edge_case_data["in_network"][0]["negotiated_rates"][0]["negotiated_prices"][0]["billing_code_modifier"] = ["AS", "59", "XS"]
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end
  end
end
