class ReportCardGenerationJob < ApplicationJob
  queue_as :default

  def perform(student_id)
    student = Student.find(student_id)
    ReportCardGenerator.call(student)
  end
end
