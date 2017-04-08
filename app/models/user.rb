class User < ApplicationRecord
  has_many :transactions

  validates :telegram_id, presence: true, uniqueness: true
end
