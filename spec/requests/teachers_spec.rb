require 'rails_helper'

RSpec.describe "Teachers", type: :request do
  let!(:admin) { User.create!(email: "admin_#{SecureRandom.hex(4)}@example.com", password: 'password', role: 'admin') }
  let!(:teacher) { User.create!(email: "teacher_#{SecureRandom.hex(4)}@example.com", password: 'password', role: 'teacher') }

  describe "GET /admin/teachers" do
    context "when signed in as admin" do
      before do
        sign_in admin
        get admin_teachers_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "renders the teachers list" do
        expect(response.body).to include(teacher.email)
      end
    end

    context "when signed in as teacher" do
      before do
        sign_in teacher
        get admin_teachers_path
      end

      it "redirects to home" do
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when not signed in" do
      before do
        get admin_teachers_path
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
