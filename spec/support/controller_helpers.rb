module ControllerHelpers
  def login_user
    before(:each) do
     @current_user = FactoryGirl.create(:user)
     allow(controller).to receive(:current_user) { @current_user }
    end
  end
end

RSpec.configure do |config|
  config.extend  ControllerHelpers, type: :controller
end
