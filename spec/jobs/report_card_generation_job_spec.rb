require 'rails_helper'

RSpec.describe ReportCardGenerationJob, type: :job do
  include ActiveJob::TestHelper

  let!(:student) { create(:student) }

  describe "#perform" do
    it "calls ReportCardGenerator and sends an email" do
      allow(Student).to receive(:find).with(student.id).and_return(student)
      allow(student.report_card).to receive(:attached?).and_return(true)

      expect(ReportCardGenerator).to receive(:call).with(satisfy { |s| s.id == student.id })

      mailer_double = double("StudentMailer")
      expect(StudentMailer).to receive(:report_card).with(satisfy { |s| s.id == student.id }).and_return(mailer_double)
      expect(mailer_double).to receive(:deliver_now)

      ReportCardGenerationJob.new.perform(student.id)
    end

    it "raises exception if student is not found" do
      expect(ReportCardGenerator).not_to receive(:call)
      expect {
        ReportCardGenerationJob.new.perform(9999)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "enqueueing" do
    it "enqueues the job" do
      expect {
        ReportCardGenerationJob.perform_later(student.id)
      }.to have_enqueued_job(ReportCardGenerationJob).with(student.id).on_queue("default")
    end
  end
end
