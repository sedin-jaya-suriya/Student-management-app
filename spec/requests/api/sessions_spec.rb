require 'rails_helper'

RSpec.describe "Api::Sessions", type: :request do
  let(:user) { create(:user, email: "test@example.com", password: "password123") }

  describe "POST /api/login" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post api_login_path, params: { email: user.email, password: "password123" }
        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("token")
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized status" do
        post api_login_path, params: { email: user.email, password: "wrong_password" }
        expect(response).to have_http_status(:unauthorized)

        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Invalid email or password")
      end
    end
  end
end
