module Api
  class StudentsController < BaseController
    before_action :set_student, only: [ :show, :update, :destroy ]

    def index
      students = student_scope
      students = students.search(params[:name]) if params[:name].present?
      students = students.by_course(params[:course]) if params[:course].present?
      students = students.by_grade(params[:grade]) if params[:grade].present?
      render json: students, status: :ok
    end

    def show
      render json: @student, status: :ok
    end

    def create
      student = Student.new(student_params)

      if params[:teacher_id] && current_user.admin?
        teacher = User.find_by(id: params[:teacher_id], role: "teacher")
        return render json: { errors: [ "Teacher not found" ] }, status: :not_found unless teacher
        student.teacher = teacher
      elsif current_user.teacher?
        student.teacher = current_user
      end

      if student.save
        render json: student, status: :created
      else
        render json: { errors: student.errors.full_messages }, status: :unprocessable_content
      end
    end

    def update
      if @student.update(student_params)
        render json: @student, status: :ok
      else
        render json: { errors: @student.errors.full_messages }, status: :unprocessable_content
      end
    end

    def destroy
      @student.destroy
      head :ok
    end

    private

    def student_scope
      current_user.admin? ? Student.all : current_user.students
    end

    def set_student
      @student = student_scope.find_by(id: params[:id])
      unless @student
        render json: { errors: [ "Student not found" ] }, status: :not_found
      end
    end

    def student_params
      params.require(:student).permit(:name, :email, :age, :course, :city, :marks, :profile_photo, documents: [])
    end
  end
end
