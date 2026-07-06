class StudentMailer < ApplicationMailer
  default from: "jayasuriya1017@gmail.com"

  def welcome_email(student)
    @student = student
    @teacher = @student.teacher

    mail(
      to: @student.email,
      subject: "Welcome to ABC Academy"
    )
  end

  def teacher_assigned(student)
    @student = student
    @teacher = student.teacher

    mail(
        to: @student.email,
        subject: "Your Teacher Has Been Assigned"
    )
    end

  def assignment_submitted(student, document)
    @student = student
    @document = document

    mail(
      to: @student.email,
      subject: "Assignment Submitted Successfully"
    )
  end

  def marks_published(student)
    @student = student

    mail(
      to: @student.email,
      subject: "Marks Published"
    )
  end

  def teacher_assigned(student)
    @student = student
    @teacher = student.teacher

    mail(
        to: @student.email,
        subject: "Teacher Assigned"
    )
    end

    def report_card(student, pdf_data)
    @student = student

    attachments["ReportCard.pdf"] = pdf_data

    mail(
        to: @student.email,
        subject: "Your Report Card"
    )
    end
end