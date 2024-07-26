# frozen_string_literal: true

require "spec_helper"

RSpec.describe UpdatePackagePrice do
  let(:stockholm) { Municipality.create!(name: "Stockholm") }
  let(:goteborg) { Municipality.create!(name: "Göteborg") }
  let(:package) { Package.create!(name: "Dunderhonung", municipality: stockholm) }

  it "updates the current price of the provided package" do
    described_class.call(package, 200_00)
    expect(package.reload.amount_cents).to eq(200_00)
  end

  it "only updates the passed package price" do
    other_package = Package.create!(name: "Farmors köttbullar", amount_cents: 100_00, municipality: goteborg)

    expect do
      described_class.call(package, 200_00)
    end.not_to(change do
      other_package.reload.amount_cents
    end)
  end

  it "stores the old price of the provided package in its price history" do
    package.update!(amount_cents: 100_00)

    described_class.call(package, 200_00)
    expect(package.prices).to be_one
    price = package.prices.first
    expect(price.amount_cents).to eq(100_00)
  end

  it "stores the municipality in the price history" do
    expect(package.municipality.name).to eq("Stockholm")
    described_class.call(package, 200_00, municipality: "Göteborg")
    expect(package.prices).to be_one
    price = package.prices.first
    expect(price.municipality.name).to eq("Stockholm")
    expect(package.reload.municipality.name).to eq("Göteborg")
  end
end
