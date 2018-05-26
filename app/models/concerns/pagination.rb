module Pagination
  extend ActiveSupport::Concern
  DEFAULT_LIMIT = 10

  module ClassMethods
    def paginate(page)
      self.limit(item_limits).offset((page.to_i - 1) * item_limits)
    end

    def page_count
      (self.except(:limit, :offset).count / item_limits.to_f).ceil
    end

    def item_limits
      self.try(:per_page) || DEFAULT_LIMIT
    end
  end
end
