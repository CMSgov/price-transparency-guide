require "spec_helper"
require "json"
require "pathname"
require "json_schemer"

describe "table of contents schema" do
  let(:schema_path) { Pathname.new("../schemas/table-of-contents/table-of-contents.json") }
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
    Dir.glob("../examples/table-of-contents/*.json").each do |example_file|
      example_name = File.basename(example_file)

      it "validates example: #{example_name}" do
        json_data = JSON.parse(File.read(example_file))
        validate_with_errors(json_data)
      end
    end
  end

  describe "negative tests - invalid data" do
    let(:valid_data) { JSON.parse(File.read("../examples/table-of-contents/table-of-contents-sample.json")) }

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

    it "rejects data missing required field: reporting_structure" do
      invalid_data = valid_data.dup
      invalid_data.delete("reporting_structure")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects uppercase plan_id_type values (should be lowercase)" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0]["plan_id_type"] = "HIOS"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid plan_id_type values" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0]["plan_id_type"] = "invalid_type"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects invalid plan_market_type values" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0]["plan_market_type"] = "invalid_market"
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty string for required fields" do
      invalid_data = valid_data.dup
      invalid_data["reporting_entity_name"] = ""
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty reporting_structure array" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"] = []
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects empty reporting_plans array" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"] = []
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects reporting_structure without in_network_files or allowed_amount_file" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0].delete("in_network_files")
      invalid_data["reporting_structure"][0].delete("allowed_amount_file")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects file location missing description" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["in_network_files"][0].delete("description")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects file location missing location URL" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["in_network_files"][0].delete("location")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects reporting_plans missing plan_name" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0].delete("plan_name")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects reporting_plans missing issuer_name" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0].delete("issuer_name")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects reporting_plans missing plan_id_type" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0].delete("plan_id_type")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects reporting_plans missing plan_id" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0].delete("plan_id")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end

    it "rejects reporting_plans missing plan_market_type" do
      invalid_data = valid_data.dup
      invalid_data["reporting_structure"][0]["reporting_plans"][0].delete("plan_market_type")
      expect(schemer.valid?(invalid_data)).to be_falsey
    end
  end

  describe "edge cases" do
    let(:valid_data) { JSON.parse(File.read("../examples/table-of-contents/table-of-contents-sample.json")) }

    it "accepts reporting_structure with only in_network_files" do
      edge_case_data = valid_data.dup
      edge_case_data["reporting_structure"][0].delete("allowed_amount_file")
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts reporting_structure with only allowed_amount_file" do
      edge_case_data = valid_data.dup
      edge_case_data["reporting_structure"][0].delete("in_network_files")
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts multiple in_network_files" do
      edge_case_data = valid_data.dup
      additional_file = {
        "description" => "Additional network file",
        "location" => "https://example.com/additional-file.json"
      }
      edge_case_data["reporting_structure"][0]["in_network_files"] << additional_file
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts multiple reporting_plans in a reporting_structure" do
      edge_case_data = valid_data.dup
      additional_plan = edge_case_data["reporting_structure"][0]["reporting_plans"][0].dup
      additional_plan["plan_id"] = "99999999"
      additional_plan["plan_name"] = "Another Plan"
      edge_case_data["reporting_structure"][0]["reporting_plans"] << additional_plan
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts multiple reporting_structure entries" do
      edge_case_data = Marshal.load(Marshal.dump(valid_data))
      additional_structure = Marshal.load(Marshal.dump(edge_case_data["reporting_structure"][0]))
      # Modify the duplicate to have different plan details to avoid conflicts
      additional_structure["reporting_plans"][0]["plan_id"] = "9999999999"
      additional_structure["reporting_plans"][0]["plan_name"] = "Different Plan"
      edge_case_data["reporting_structure"] << additional_structure
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts plan_sponsor_name when plan_id_type is ein" do
      edge_case_data = valid_data.dup
      edge_case_data["reporting_structure"][0]["reporting_plans"][0]["plan_id_type"] = "ein"
      edge_case_data["reporting_structure"][0]["reporting_plans"][0]["plan_id"] = "12-3456789"
      edge_case_data["reporting_structure"][0]["reporting_plans"][0]["plan_sponsor_name"] = "Test Sponsor"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts HTTPS URLs for file locations" do
      edge_case_data = valid_data.dup
      edge_case_data["reporting_structure"][0]["in_network_files"][0]["location"] = "https://secure.example.com/files/network.json"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end

    it "accepts valid ISO 8601 date format" do
      edge_case_data = valid_data.dup
      edge_case_data["last_updated_on"] = "2024-12-31"
      expect(schemer.valid?(edge_case_data)).to be_truthy
    end
  end
end
