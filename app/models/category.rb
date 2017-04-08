class Category < ApplicationRecord
  FINANCIAL_TYPES = %w(income expense)

  has_many :transactions

  validates :name, presence: true
  validates :financial_type, :inclusion => FINANCIAL_TYPES
end
