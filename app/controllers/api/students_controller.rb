module Api
  class StudentsController < BaseController
    before_action :set_student, only: [:show, :update, :destroy]
    #  skip_before_action :verify_authenticity_token

    # GET /students
    # GET /students
    def index
      students = student_scope
      students = students.by_name(params[:name]) if params[:name].present?
      students = students.by_course(params[:course]) if params[:course].present?
      students = students.by_grade(params[:grade]) if params[:grade].present?
      render json: students, status: :ok
    end
    
    # GET /students/:id
    def show
      render json: @student.slice(:id, :name, :email, :age, :course, :city, :marks), status: :ok
    end

    # POST /students
    def create
        @student = Student.new(student_params)

        if params[:teacher_id]
            teacher = User.find_by(id: params[:teacher_id], role: 'teacher')
            return render json: { errors: ['Teacher not found'] }, status: :not_found unless teacher
            @student.teacher = teacher
        elsif current_user.teacher?
            @student.teacher = current_user
        end

        if @student.save
            render json: @student.slice(:id, :name), status: :created
        else
            render json: {
            errors: @student.errors.full_messages
            }, status: :unprocessable_entity
        end
    end

    # PUT/PATCH /students/:id
    def update
      if @student.update(student_params)
        render json: @student.slice(:id, :name, :email, :age, :course, :city, :marks), status: :ok
      else
        render_unprocessable(@student)
      end
    end

    # DELETE /students/:id
    def destroy
      @student.destroy
      head :ok
    end

    private

    def student_scope
      current_user.admin? ? Student.all : current_user.students
    end

    def set_student
      @student = student_scope.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['Student not found'] }, status: :not_found
    end

    def student_params
      params.require(:student).permit(:name, :email, :age, :course, :city, :marks, :teacher_id)
    end
  end
end

module Api
  class StudentsController < Api::BaseController
    before_action :set_student, only: %i[show update destroy]

    # GET /api/students
    def index
      students = Student.all
      students = students.search(params[:name]) if params[:name].present?
      students = students.by_course(params[:course]) if params[:course].present?
      students = students.by_grade(params[:grade]) if params[:grade].present?

      render json: students, status: :ok
    end

    # GET /api/students/:id
    def show
      render json: @student, status: :ok
    end

    # POST /api/students
    def create
      student = Student.new(student_params)
      student.teacher_id = current_user.id unless current_user.admin?

      if student.save
        render json: student, status: :created
      else
        render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PUT/PATCH /api/students/:id
    def update
      if @student.update(student_params)
        render json: @student, status: :ok
      else
        render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/students/:id
    def destroy
      @student.destroy
      head :no_content
    end

    private

    def set_student
      @student = Student.find_by(id: params[:id])

      unless @student
        render json: { errors: ['Student not found'] }, status: :not_found
      end
    end

    def student_params
      permitted = [
        :name,
        :email,
        :age,
        :course,
        :city,
        :marks
      ]

      permitted << :teacher_id if current_user.admin?

      if params.key?(:student)
        params.require(:student).permit(permitted)
      else
        params.permit(permitted)
      end
    end
  end
end