class UserInitService
  attr_accessor :user_data
  def initialize(user_data)
    self.user_data = user_data
  end

  def perform
    User.create_with(name_params).find_or_create_by(telegram_id: user_id)
  end

  private

  def name_params
    {
      first_name: first_name,
      last_name: last_name
    }
  end

  def user_id
    user_data["id"]
  end

  def first_name
    user_data["first_name"]
  end

  def last_name
    user_data["last_name"]
  end
end
