class DashboardController < ApplicationController
  before_action :require_admin, only: [:admin]
  before_action :require_teacher, only: [:teacher]

  def home
    if current_user.admin?
      redirect_to admin_dashboard_path
    else
      redirect_to teacher_dashboard_path
    end
  end

  def admin
    @total_students = Student.count
    @total_teachers = User.teacher.count
    @teachers = User.teacher.left_joins(:students)
                    .select("users.*, COUNT(students.id) AS students_count")
                    .group("users.id")
  end

  def teacher
    students = current_user.students

    @total_students = students.count
    @ruby_students  = students.where(course: "Ruby").count
    @rails_students = students.where(course: "Rails").count
    @react_students = students.where(course: "React").count
    @java_students  = students.where(course: "Java").count
  end

  private

  def require_admin
    redirect_to teacher_dashboard_path unless current_user.admin?
  end

  def require_teacher
    redirect_to admin_dashboard_path unless current_user.teacher?
  end
end