class Category < ApplicationRecord
  FINANCIAL_TYPES = %w(income expense)
  validates :name, presence: true
  validates :financial_type, :inclusion => FINANCIAL_TYPES
end
