class StudentNotificationService
  def self.notify_creation(student, params)
    StudentMailer.welcome_email(student).deliver_now

    if student.teacher.present?
      StudentMailer.teacher_assigned(student).deliver_now
      TeacherMailer.new_student(student).deliver_now
    end

    notify_assignments(student, params)
  end

  def self.notify_update(student, old_marks, old_teacher_id, params)
    if old_marks != student.marks
      StudentMailer.marks_published(student).deliver_now
    end

    if old_teacher_id != student.teacher_id && student.teacher.present?
      StudentMailer.teacher_assigned(student).deliver_now
      TeacherMailer.new_student(student).deliver_now
    end

    notify_assignments(student, params)
  end

  def self.notify_assignments(student, params)
    assignments_param = params.dig(:student, :assignments)
    return unless assignments_param.present?

    # Remove any empty strings (often sent by Rails file upload forms)
    new_assignments_count = assignments_param.reject(&:blank?).count
    return unless new_assignments_count > 0

    student.assignments.last(new_assignments_count).each do |assignment|
      StudentMailer.assignment_submitted(student, assignment).deliver_now
    end
  end
end
