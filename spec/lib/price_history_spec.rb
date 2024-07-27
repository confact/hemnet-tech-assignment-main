require 'rails_helper'

RSpec.describe PriceHistory do
  let(:stockholm) { Municipality.create!(name: "Stockholm") }
  let(:goteborg) { Municipality.create!(name: "Göteborg") }
  let!(:package_premium) { Package.create!(name: "premium", municipality: stockholm) }
  let!(:package_bas) { Package.create!(name: "bas", municipality: goteborg) }

  before do
    Price.create!(package: package_premium, amount_cents: 100_00, municipality: stockholm, created_at: "2023-04-01")
    Price.create!(package: package_premium, amount_cents: 125_00, municipality: stockholm, created_at: "2023-08-02")
    Price.create!(package: package_premium, amount_cents: 175_00, municipality: stockholm, created_at: "2023-12-24")
    Price.create!(package: package_premium, amount_cents: 25_00, municipality: goteborg, created_at: "2022-09-01")
    Price.create!(package: package_premium, amount_cents: 50_00, municipality: goteborg, created_at: "2023-02-03")
    Price.create!(package: package_premium, amount_cents: 75_00, municipality: goteborg, created_at: "2023-05-20")
    Price.create!(package: package_bas, amount_cents: 100_00, municipality: goteborg, created_at: "2023-06-01")
  end

  context "error handling" do
    it "raises an error if the year is not valid" do
      expect { described_class.call(year: "202", package: package_premium.name) }.to raise_error(ArgumentError)
    end

    it "raises an error if the package is not a string" do
      expect { described_class.call(year: "2023", package: 123) }.to raise_error(ArgumentError)
    end

    it "raises an error if the year is not filled" do
      expect { described_class.call(package: package_premium.name) }.to raise_error(ArgumentError)
    end

    it "raises an error if the package is not filled" do
      expect { described_class.call(year: "2023") }.to raise_error(ArgumentError)
    end
  end

  it "fetches price history for a package in a given year" do
    result = described_class.call(year: "2023", package: package_premium.name)

    expect(result).to eq({
      "Stockholm" => [100_00, 125_00, 175_00],
      "Göteborg" => [50_00, 75_00]
    })
  end

  it "fetches price history for a package in a given year and municipality" do
    result = described_class.call(year: "2023", package: package_premium.name, municipality: "Göteborg")

    expect(result).to eq({
      "Göteborg" => [50_00, 75_00]
    })
  end

  it "returns an empty hash if the package does not exist" do
    result = described_class.call(year: "2023", package: "nonexistent")

    expect(result).to eq({})
  end

  it "returns an empty hash if there are no prices in the given year" do
    result = described_class.call(year: "2021", package: "premium")

    expect(result).to eq({})
  end
end
