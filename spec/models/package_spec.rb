# frozen_string_literal: true

require "spec_helper"

RSpec.describe Package do
  it "validates the presence of name" do
    package = described_class.new(name: nil)
    expect(package.validate).to be(false)
    expect(package.errors[:name]).to be_present
  end

  it "validates the presence of price_cents" do
    package = described_class.new(amount_cents: nil)
    expect(package.validate).to be(false)
    expect(package.errors[:amount_cents]).to be_present
  end

  it "validates the presence of municipality" do
    package = described_class.new(municipality: nil)
    expect(package.validate).to be(false)
    expect(package.errors[:municipality]).to be_present
  end
end
