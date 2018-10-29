class Transaction < ApplicationRecord
  include Pagination
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true
  validates :amount, numericality: true, if: :amount

  scope :current_month, -> { where("transactions.created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current) }
  scope :by_financial_type, ->(financial_type) { joins(:category).where("categories.financial_type = ?", financial_type)  }
  scope :return_last, ->(number) { order("transactions.created_at DESC").limit(number)  }
end
