class ReportCardGenerationJob < ApplicationJob
  queue_as :default

  def perform(student_id)
    student = Student.find_by(id: student_id)
    return unless student

    ReportCardGenerator.call(student)
    StudentMailer.report_card(student).deliver_now
  end
end
