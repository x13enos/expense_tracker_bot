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

    context "when token was passed in request headers" do
      it "should return user if token valid" do
        request.env['HTTP_AUTHORIZATION'] = "Bearer #{AuthService.encode(user.id)}"
        controller.current_user
        expect(request.cookies[:token]).to be_nil
      end

      it "should return nil if token is expired" do
        request.env['HTTP_AUTHORIZATION'] = "Bearer #{AuthService.encode(user.id)}"
        travel 16.minutes do
          expect(controller.current_user).to be_nil
        end
      end
    end

    context "when token was kept in cookies" do
      it "should return user if token valid" do
        request.cookies[:token] = "Bearer #{AuthService.encode(user.id)}"
        expect(controller.current_user).to eq(user)
      end

      it "should remove token from cookies" do
        cookies[:token] = "Bearer #{AuthService.encode(user.id)}"
        allow(controller).to receive(:cookies).and_return(cookies)
        controller.current_user
        expect(request.cookies[:token]).to be_nil
      end

      it "should return nil if token is expired" do
        request.cookies[:token] = "Bearer #{AuthService.encode(user.id)}"
        travel 16.minutes do
          expect(controller.current_user).to be_nil
        end
      end
    end

    it "should return nil if token wasn't passed" do
      request.env['HTTP_AUTHORIZATION'] = nil
      expect(controller.current_user).to be_nil
    end

    it "should return false if token doesn't contain data about user" do
      request.cookies[:token] = nil
      request.env['HTTP_AUTHORIZATION'] = nil
      expect(controller.current_user).to be_falsey
    end
  end
end
