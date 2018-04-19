class Category < ApplicationRecord
  FINANCIAL_TYPES = %w(income expense)

  belongs_to :user
  has_many :transactions

  validates :name, :user, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validates :name, exclusion: { in: I18n.t('telegram.categories.types') }
  validates :financial_type, :inclusion => FINANCIAL_TYPES

  scope :income, -> { where(financial_type: "income") }
  scope :expense, -> { where(financial_type: "expense") }

  def expense?
    financial_type == "expense"
  end
end
