class User < ApplicationRecord
  validates :telegram_id, presence: true
end
