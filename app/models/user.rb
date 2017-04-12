class User < ApplicationRecord
  has_many :transactions
  has_many :categories

  validates :telegram_id, presence: true, uniqueness: true

  def full_name
    [first_name, last_name].join(" ")
  end
end
