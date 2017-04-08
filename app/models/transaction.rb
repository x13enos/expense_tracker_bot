class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :user_id, :category_id, :amount, :presence => true
  validates :amount, numericality: true
end
