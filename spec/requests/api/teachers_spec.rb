require 'rails_helper'

RSpec.describe "Api::Teachers", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:teacher) { create(:user, :teacher, name: "Mr. Smith", subject: "Math") }
  let!(:student) { create(:student, teacher: teacher, name: "Alice") }
  
  let(:valid_headers) do
    token = JsonWebToken.encode(user_id: admin.id)
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /api/teachers" do
    it "returns a list of teachers" do
      get api_teachers_path, headers: valid_headers
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response.length).to be > 0
      expect(json_response.map { |t| t["name"] }).to include("Mr. Smith")
    end

    it "filters teachers by subject" do
      get api_teachers_path, params: { subject: "Math" }, headers: valid_headers
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
    end
  end

  describe "GET /api/teachers/:id" do
    it "returns the teacher with their students" do
      get api_teacher_path(teacher), headers: valid_headers
      expect(response).to have_http_status(:ok)
      
      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq("Mr. Smith")
      expect(json_response["students"].length).to eq(1)
      expect(json_response["students"].first["name"]).to eq("Alice")
    end
  end

  describe "POST /api/teachers" do
    let(:valid_params) do
      {
        teacher: {
          name: "Mrs. Jones",
          email: "jones@example.com",
          subject: "Science",
          password: "password"
        }
      }
    end

    it "creates a new teacher" do
      expect {
        post api_teachers_path, params: valid_params, headers: valid_headers
      }.to change(User, :count).by(1)
      
      expect(response).to have_http_status(:created)
      expect(User.last.role).to eq("teacher")
    end
  end

  describe "PATCH /api/teachers/:id" do
    it "updates the teacher" do
      patch api_teacher_path(teacher), params: { teacher: { name: "Mr. Smith Updated" } }, headers: valid_headers
      expect(response).to have_http_status(:ok)
      
      teacher.reload
      expect(teacher.name).to eq("Mr. Smith Updated")
    end
  end

  describe "DELETE /api/teachers/:id" do
    it "deletes the teacher" do
      expect {
        delete api_teacher_path(teacher), headers: valid_headers
      }.to change(User, :count).by(-1)
      
      expect(response).to have_http_status(:ok)
    end
  end
end
