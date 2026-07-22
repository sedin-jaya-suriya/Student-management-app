require 'rails_helper'

RSpec.describe "Api::Students", type: :request do
  let(:teacher) { create(:user, :teacher) }
  let(:admin) { create(:user, :admin) }
  let!(:student) { create(:student, teacher: teacher, name: "Alice", course: "Ruby", marks: 95) }

  let(:valid_headers) do
    token = JsonWebToken.encode(user_id: teacher.id)
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /api/students" do
    it "returns students belonging to the teacher" do
      get api_students_path, headers: valid_headers
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
      expect(json_response.first["name"]).to eq("Alice")
    end

    it "filters students by name" do
      get api_students_path, params: { name: "Alice" }, headers: valid_headers
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(1)
    end
  end

  describe "GET /api/students/:id" do
    it "returns the specific student" do
      get api_student_path(student), headers: valid_headers
      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response["name"]).to eq("Alice")
    end

    it "returns not found for non-existent student" do
      get api_student_path(id: 9999), headers: valid_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/students" do
    let(:valid_params) do
      {
        student: {
          name: "Bob",
          email: "bob@example.com",
          age: 22,
          course: "Rails",
          city: "Chicago",
          marks: 80
        }
      }
    end

    it "creates a new student for the current teacher" do
      expect {
        post api_students_path, params: valid_params, headers: valid_headers
      }.to change(Student, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(Student.last.teacher_id).to eq(teacher.id)
    end

    it "returns unprocessable entity with invalid params" do
      post api_students_path, params: { student: { name: "" } }, headers: valid_headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/students/:id" do
    it "updates the student" do
      patch api_student_path(student), params: { student: { name: "Alice Updated" } }, headers: valid_headers
      expect(response).to have_http_status(:ok)

      student.reload
      expect(student.name).to eq("Alice Updated")
    end
  end

  describe "DELETE /api/students/:id" do
    it "deletes the student" do
      expect {
        delete api_student_path(student), headers: valid_headers
      }.to change(Student, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
