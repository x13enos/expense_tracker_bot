class Category < ApplicationRecord
  FINANCIAL_TYPES = %w(income expense)

  belongs_to :user
  has_many :transactions

  validates :name, :user, presence: true
  validates :financial_type, :inclusion => FINANCIAL_TYPES
end
