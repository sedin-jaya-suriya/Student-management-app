require "rails_helper"

RSpec.describe TeacherMailer, type: :mailer do
  let(:teacher) { create(:user, :teacher) }
  let(:student) { create(:student, teacher: teacher) }

  describe "new_student" do
    let(:mail) { TeacherMailer.new_student(student) }

    it "renders the headers" do
      expect(mail.subject).to eq("New Student Assigned")
      expect(mail.to).to eq([teacher.email])
      expect(mail.from).to eq(["jayasuriya1017@gmail.com"])
    end
  end
end
