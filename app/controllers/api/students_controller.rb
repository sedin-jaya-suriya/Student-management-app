module Api
  class StudentsController < BaseController
    before_action :set_student, only: [:show, :update, :destroy]
    #  skip_before_action :verify_authenticity_token

    # GET /students
    def index
      students = student_scope
      students = students.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
      students = students.where(marks: params[:grade]) if params[:grade].present? # assuming grade maps to marks or course
      students = students.select(:id, :name, :email, :age, :course, :city, :marks)
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
