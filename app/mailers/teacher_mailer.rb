class TeacherMailer < ApplicationMailer
  default from: "jayasuriya1017@gmail.com"

  def new_student(student)
    @student = student
    @teacher = student.teacher

    mail(
      to: @teacher.email,
      subject: "New Student Assigned"
    )
  end
end