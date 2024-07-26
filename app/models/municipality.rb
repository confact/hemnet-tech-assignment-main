# frozen_string_literal: true

# I made this first as a string column in the prices & packages tables
# but then I thought it would be good to find prices based on the municipality
# so I changed it to a Model and added a relationship
class Municipality < ApplicationRecord
  has_many :packages, dependent: :destroy
  has_many :prices, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  before_validation :capitalize_name

  private

  def capitalize_name
    self.name = name.capitalize if name.present?
  end
end
