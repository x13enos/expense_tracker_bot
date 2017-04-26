class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :user_id, :category_id, :amount, :presence => true
  validates :amount, numericality: true

  scope :current_month, -> { where("transactions.created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current) }
end
