require 'rails_helper'

RSpec.describe "Students", type: :request do
  let(:teacher) { create(:user, :teacher) }
  let(:admin) { create(:user, :admin) }
  let!(:student) { create(:student, teacher: teacher) }

  before do
    sign_in teacher
  end

  describe "GET /students" do
    it "returns http success" do
      get students_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(student.name)
    end
  end

  describe "GET /students/:id" do
    it "returns http success" do
      get student_path(student)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /students/new" do
    it "returns http success" do
      get new_student_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /students/:id/edit" do
    it "returns http success" do
      get edit_student_path(student)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /students" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          student: {
            name: "John Doe",
            email: "john@example.com",
            age: 21,
            course: "Rails",
            city: "Boston",
            marks: 90
          }
        }
      end

      it "creates a new Student" do
        expect {
          post students_path, params: valid_params
        }.to change(Student, :count).by(1)
      end

      it "redirects to the created student" do
        post students_path, params: valid_params
        expect(response).to redirect_to(student_url(Student.last))
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          student: {
            name: "",
            email: "invalid",
            age: -1
          }
        }
      end

      it "does not create a new Student" do
        expect {
          post students_path, params: invalid_params
        }.to change(Student, :count).by(0)
      end

      it "returns an unprocessable entity status" do
        post students_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /students/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "Updated Name" } }

      it "updates the requested student" do
        patch student_path(student), params: { student: new_attributes }
        student.reload
        expect(student.name).to eq("Updated Name")
      end

      it "redirects to the student" do
        patch student_path(student), params: { student: new_attributes }
        student.reload
        expect(response).to redirect_to(student_url(student))
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity status" do
        patch student_path(student), params: { student: { name: "" } }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /students/:id" do
    it "destroys the requested student" do
      expect {
        delete student_path(student)
      }.to change(Student, :count).by(-1)
    end

    it "redirects to the students list" do
      delete student_path(student)
      expect(response).to redirect_to(students_url)
    end
  end

  describe "DELETE /students/:id/remove_profile_photo" do
    let(:student_with_photo) { create(:student, :with_photo, teacher: teacher) }

    it "removes the profile photo" do
      delete remove_profile_photo_student_path(student_with_photo)
      student_with_photo.reload
      expect(student_with_photo.profile_photo).not_to be_attached
    end
  end

  describe "DELETE /students/:id/remove_document" do
    let(:student_with_doc) { create(:student, :with_document, teacher: teacher) }

    it "removes the document" do
      attachment = student_with_doc.documents.first
      delete remove_document_student_path(student_with_doc, attachment_id: attachment.id)
      student_with_doc.reload
      expect(student_with_doc.documents).to be_empty
    end
  end

  describe "POST /students/:id/generate_report" do
    it "enqueues a report generation job and redirects" do
      expect {
        post generate_report_student_path(student)
      }.to have_enqueued_job(ReportCardGenerationJob).with(student.id)

      expect(response).to redirect_to(student_path(student))
      expect(flash[:notice]).to eq("Report generation has been queued successfully.")
    end
  end
end
