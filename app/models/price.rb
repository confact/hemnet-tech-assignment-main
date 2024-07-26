# frozen_string_literal: true

class Price < ApplicationRecord
  belongs_to :package, optional: false
  belongs_to :municipality, optional: true

  validates :amount_cents, presence: true
  # no validation for municipality as these records could have old prices
  # and we might not have the municipality information for them
  # validates :municipality, presence: true
end
