require 'rails_helper'

RSpec.describe ReportCardGenerator do
  let(:student) { create(:student, name: "Alice", course: "Ruby", marks: 95) }

  describe ".call" do
    it "generates and attaches a report card PDF to the student" do
      expect {
        ReportCardGenerator.call(student)
      }.to change { student.report_card.attached? }.from(false).to(true)
      
      expect(student.report_card.filename.to_s).to eq("ReportCard_#{student.id}.pdf")
      expect(student.report_card.content_type).to eq("application/pdf")
    end
  end
end
