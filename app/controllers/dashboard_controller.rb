class DashboardController < ApplicationController
  before_action :require_admin!, only: %i[admin teachers]
  before_action :require_teacher!, only: %i[teacher]

  # Public landing page for the app
  def index
    return redirect_to admin_dashboard_path if user_signed_in? && current_user.admin?
    redirect_to teacher_dashboard_path if user_signed_in? && current_user.teacher?
  end

  def home
    return redirect_to admin_dashboard_path if current_user.admin?
    return redirect_to teacher_dashboard_path if current_user.teacher?
    redirect_to root_path, alert: "Unauthorized access."
  end

  def admin
    @total_students = Student.count
    @total_teachers = User.teacher.count
    @teachers = User.teacher.left_joins(:students)
                    .select("users.*, COUNT(students.id) AS students_count")
                    .group("users.id")
  end

  def teachers
    @teachers = User.teacher.left_joins(:students)
                    .select("users.*, COUNT(students.id) AS students_count")
                    .group("users.id")
  end

  def teacher
    students = current_user.students
    @total_students = students.count
    @course_counts = students.group(:course).count
  end
end
