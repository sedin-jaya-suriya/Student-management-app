require "rails_helper"

RSpec.describe StudentMailer, type: :mailer do
  let(:teacher) { create(:user, :teacher) }
  let(:student) { create(:student, teacher: teacher) }

  describe "welcome_email" do
    let(:mail) { StudentMailer.welcome_email(student) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to ABC Academy")
      expect(mail.to).to eq([student.email])
      expect(mail.from).to eq(["jayasuriya1017@gmail.com"])
    end
  end

  describe "teacher_assigned" do
    let(:mail) { StudentMailer.teacher_assigned(student) }

    it "renders the headers" do
      expect(mail.subject).to eq("Teacher Assigned")
      expect(mail.to).to eq([student.email])
      expect(mail.from).to eq(["jayasuriya1017@gmail.com"])
    end
  end

  describe "assignment_submitted" do
    let(:document) { double("document", filename: "test.pdf", created_at: Time.current) }
    let(:mail) { StudentMailer.assignment_submitted(student, document) }

    it "renders the headers" do
      expect(mail.subject).to eq("Assignment Submitted Successfully")
      expect(mail.to).to eq([student.email])
      expect(mail.from).to eq(["jayasuriya1017@gmail.com"])
    end
  end

  describe "marks_published" do
    let(:mail) { StudentMailer.marks_published(student) }

    it "renders the headers" do
      expect(mail.subject).to eq("Marks Published")
      expect(mail.to).to eq([student.email])
      expect(mail.from).to eq(["jayasuriya1017@gmail.com"])
    end
  end

  describe "report_card" do
    let(:mail) { StudentMailer.report_card(student) }

    it "renders the headers" do
      expect(mail.subject).to eq("Your Report Card is Ready")
      expect(mail.to).to eq([student.email])
      expect(mail.from).to eq(["jayasuriya1017@gmail.com"])
    end
  end
end
