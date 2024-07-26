# frozen_string_literal: true

require "spec_helper"

RSpec.describe Municipality do
  it "validates the presence of name" do
    municipality = described_class.new(name: nil)
    expect(municipality.validate).to be(false)
    expect(municipality.errors[:name]).to be_present
  end

  it "validates the uniqueness of name" do
    described_class.create(name: "Stockholm")
    municipality = described_class.new(name: "Stockholm")
    expect(municipality.validate).to be(false)
    expect(municipality.errors[:name]).to be_present
  end

  it "has many packages" do
    municipality = described_class.new(name: "Stockholm")
    expect(municipality.packages).to eq([])
  end

  it "has many prices" do
    municipality = described_class.new(name: "Stockholm")
    expect(municipality.prices).to eq([])
  end

  context "before validation" do
    it "capitalizes the name" do
      municipality = described_class.new(name: "stockholm")
      municipality.valid?
      expect(municipality.name).to eq("Stockholm")
    end
  end
end