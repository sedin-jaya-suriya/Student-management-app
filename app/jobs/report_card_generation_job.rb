class ReportCardGenerationJob < ApplicationJob
  queue_as :default

  def perform(student_id)
    student = Student.find(student_id)

    ReportCardGenerator.call(student)

    if student.report_card.attached?
      StudentMailer.report_card(student).deliver_now
    end
  end
end
