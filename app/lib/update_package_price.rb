# frozen_string_literal: true

class UpdatePackagePrice
  def self.call(package, new_price_cents, **options)
    municipality_name = options[:municipality]
    municipality = Municipality.find_or_create_by(name: municipality_name) if municipality_name.present?

    Package.transaction do
      # Add a pricing history record with the current municipality
      Price.create!(package: package, amount_cents: package.amount_cents, municipality: package.municipality)

      # Update the current price and optionally the municipality
      update_params = { amount_cents: new_price_cents }
      update_params[:municipality] = municipality if municipality.present?
      package.update!(update_params)
    end
  end
end
