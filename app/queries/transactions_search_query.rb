class TransactionsSearchQuery
  attr_accessor :relation, :conditions

  def initialize(relation, conditions)
    self.relation = relation
    self.conditions = conditions
  end

  def all
    return relation unless conditions
    self.relation = search_by_category
    self.relation = search_by_start_date
    self.relation = search_by_end_date
    return relation
  end

  private

  def search_by_category
    value = conditions[:category_id]
    return relation unless value.present?
    relation.where(category_id: value)
  end

  def search_by_start_date
    date = conditions[:start_date]
    return relation unless date.present?
    relation.where("created_at >= ?", date)
  end

  def search_by_end_date
    date = conditions[:end_date]
    return relation unless date.present?
    relation.where("created_at <= ?", date)
  end
end
