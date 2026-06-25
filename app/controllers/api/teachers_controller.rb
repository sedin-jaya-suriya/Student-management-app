module Api
  class TeachersController < BaseController
    before_action :set_teacher, only: [:show, :update, :destroy]

    # GET /teachers
    def index
      teachers = User.where(role: 'teacher')
      teachers = teachers.where(subject: params[:subject]) if params[:subject].present?
      render json: teachers.select(:id, :name, :subject), status: :ok
    end

    # GET /teachers/:id
    def show
      render json: teacher_with_students(@teacher), status: :ok
    end

    # POST /teachers
    def create
      teacher = User.new(teacher_params.merge(role: 'teacher'))
      if teacher.save
        render json: teacher.slice(:id, :name, :subject), status: :created
      else
        render_unprocessable(teacher)
      end
    end

    # PUT/PATCH /teachers/:id
    def update
      if @teacher.update(teacher_params)
        render json: @teacher.slice(:id, :name, :subject), status: :ok
      else
        render_unprocessable(@teacher)
      end
    end

    # DELETE /teachers/:id
    def destroy
      @teacher.destroy
      head :ok
    end

    private

    def set_teacher
      @teacher = User.where(role: 'teacher').find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['Teacher not found'] }, status: :not_found
    end

    def teacher_params
      params.require(:teacher).permit(:name, :email, :subject, :password)
    end

    def teacher_with_students(teacher)
      {
        id: teacher.id,
        name: teacher.name,
        subject: teacher.subject,
        students: teacher.students.select(:id, :name)
      }
    end
  end
end
