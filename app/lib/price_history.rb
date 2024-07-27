# frozen_string_literal: true

class PriceHistory
  def self.call(year:, package:, **options)
    raise ArgumentError, "Year must be a valid number" unless year.to_i > 2000
    raise ArgumentError, "Package must be a valid string" unless package.is_a?(String)

    package = Package.find_by(name: package)
    return {} unless package

    # Find the municipality if provided
    municipality = Municipality.find_by(name: options[:municipality]) if options[:municipality].present?

    # Create a date range for the given year 
    # from 00:00:00 1st January to 23:59:59 31st December
    start_date = Date.new(year.to_i, 1, 1).beginning_of_day
    end_date = start_date.end_of_year

    prices = package.prices.includes(:municipality).where(created_at: start_date..end_date)
    # Filter by municipality if provided
    prices = prices.where(municipality:) if municipality

    # Group prices by municipality and return the amounts
    # in an array
    prices.group_by { |price| price.municipality&.name || "Unknown" }.transform_values do |prices|
      prices.map { |price| price.amount_cents }
    end

    # alternative implementation:
    # if the database was postgres we could use array_agg to return the amounts in an array, like (not tested):
    # Price.joins(:municipality).where(created_at: start_date..end_date, package: package).group("municipalities.name").pluck("array_agg(amount_cents)")
  end
end
