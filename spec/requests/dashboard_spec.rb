require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:teacher) { create(:user, :teacher) }

  describe "GET /" do
    context "when admin is logged in" do
      before do
        sign_in admin
        get root_path
      end

      it "redirects to admin dashboard" do
        expect(response).to redirect_to(admin_dashboard_path)
      end
    end

    context "when teacher is logged in" do
      before do
        sign_in teacher
        get root_path
      end

      it "redirects to teacher dashboard" do
        expect(response).to redirect_to(teacher_dashboard_path)
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /admin_dashboard" do
    context "when admin is logged in" do
      before do
        sign_in admin
        get admin_dashboard_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when teacher is logged in" do
      before do
        sign_in teacher
        get admin_dashboard_path
      end

      it "redirects to root path" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/teachers" do
    context "when admin is logged in" do
      before do
        sign_in admin
        get admin_teachers_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /teacher_dashboard" do
    context "when teacher is logged in" do
      before do
        sign_in teacher
        get teacher_dashboard_path
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when admin is logged in" do
      before do
        sign_in admin
        get teacher_dashboard_path
      end

      it "redirects to root path" do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
