class Transaction < ApplicationRecord
  include Pagination
  belongs_to :user
  belongs_to :category

  validates :user_id, :category_id, :amount, :presence => true
  validates :amount, numericality: true, if: :amount

  scope :current_month, -> { where("transactions.created_at BETWEEN ? AND ?", Time.current.beginning_of_month, Time.current) }
  scope :by_financial_type, ->(financial_type) { joins(:category).where("categories.financial_type = ?", financial_type)  }
  scope :return_last, ->(number) { order("transactions.created_at DESC").limit(number)  }

  def self.search(conditions)
    return self unless conditions
    t = self
    t = search_by_category(t, conditions[:category_id])
    t = search_by_start_date(t, conditions[:start_date])
    t = search_by_end_date(t, conditions[:end_date])
    return t
  end

  private

  def self.search_by_category(transactions, value)
    return transactions unless value.present?
    transactions.where(category_id: value)
  end

  def self.search_by_start_date(transactions, date)
    return transactions unless date.present?
    transactions.where("created_at >= ?", date)
  end

  def self.search_by_end_date(transactions, date)
    return transactions unless date.present?
    transactions.where("created_at <= ?", date)
  end
end
