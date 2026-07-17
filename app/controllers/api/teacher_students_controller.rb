module Api
  class TeacherStudentsController < Api::BaseController
    before_action :set_teacher

    # GET /api/teachers/:teacher_id/students
    def index
      students = @teacher.students
      render json: students.map { |s| { id: s.id, name: s.name, email: s.email } }, status: :ok
    end

    # POST /api/teachers/:teacher_id/students
    def create
      student = @teacher.students.build(permitted_student_params)

      if student.save
        render json: { id: student.id, name: student.name, email: student.email }, status: :created
      else
        render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_teacher
      @teacher = User.find_by(id: params[:teacher_id], role: 'teacher')
      render json: { errors: ['Teacher not found'] }, status: :not_found unless @teacher
    end

    def permitted_student_params
      if params.key?(:student)
        params.require(:student).permit(:name, :email, :age, :course, :city, :marks)
      else
        params.permit(:name, :email, :age, :course, :city, :marks)
      end
    end
  end
end