require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  describe "logged_in?" do
    let(:user) { create(:user) }

    it "should return true if user was authorized" do
      allow(controller).to receive(:current_user) { user }
      expect(controller.logged_in?).to be_truthy
    end

    it "should return false if user wasn't authorized or found" do
      allow(controller).to receive(:current_user) { nil }
      expect(controller.logged_in?).to be_falsey
    end
  end

  describe "current_user" do
    let(:user) { create(:user) }

    context "when token was passed" do
      it "should return user if system found that by decoded token" do
        request.env['HTTP_AUTHORIZATION'] = "Bearer #{AuthService.encode(user.id)}"
        expect(controller.current_user).to eq(user)
      end

      it "should raise error if user passed token for unexisting user" do
        request.env['HTTP_AUTHORIZATION'] = "Bearer #{AuthService.encode(user.id + 1)}"
        expect { controller.current_user }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should return nil if user passed expired token" do
        request.env['HTTP_AUTHORIZATION'] = "Bearer #{AuthService.encode(user.id)}"
        travel 16.minutes do
          expect(controller.current_user).to be_nil
        end
      end
    end

    it "should return nil if token wasn't passed" do
      request.env['HTTP_AUTHORIZATION'] = nil
      expect(controller.current_user).to be_nil
    end
  end
end
