# frozen_string_literal: true

require "spec_helper"

RSpec.describe Price do
  it "validates the presence of price_cents" do
    price = described_class.new
    expect(price.validate).to be(false)
    expect(price.errors[:amount_cents]).to be_present
  end

  it "validates the presence of package" do
    price = described_class.new
    expect(price.validate).to be(false)
    expect(price.errors[:package]).to be_present
  end

  it "belongs to a package" do
    price = described_class.new
    expect(price.package).to be_nil
  end
end
