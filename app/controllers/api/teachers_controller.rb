module Api
  class TeachersController < Api::BaseController
    before_action :authorize_admin!, only: %i[create update destroy]
    before_action :set_teacher, only: %i[show update destroy]

    # GET /api/teachers
    def index
      teachers = if current_user.admin?
                  User.includes(:students).where(role: "teacher")
      else
                  User.includes(:students).where(id: current_user.id)
      end

      teachers = teachers.where("subject LIKE ?", "%#{params[:subject]}%") if params[:subject].present?
      render json: teachers.map { |teacher| teacher_hash(teacher) }, status: :ok
    end

    # GET /api/teachers/:id
    def show
      render json: teacher_hash(@teacher, include_students: true), status: :ok
    end

    # POST /api/teachers
    def create
      teacher = User.new(permitted_teacher_params.merge(role: "teacher"))

      if teacher.save
        render json: teacher_hash(teacher), status: :created
      else
        render json: { errors: teacher.errors.full_messages }, status: :unprocessable_content
      end
    end

    # PUT/PATCH /api/teachers/:id
    def update
      if @teacher.update(permitted_teacher_params)
        render json: teacher_hash(@teacher), status: :ok
      else
        render json: { errors: @teacher.errors.full_messages }, status: :unprocessable_content
      end
    end

    # DELETE /api/teachers/:id
    def destroy
      @teacher.destroy
      head :ok
    end

    private

    def set_teacher
      @teacher = if current_user.admin?
                  User.includes(:students).find_by(id: params[:id], role: "teacher")
      elsif current_user.id.to_s == params[:id].to_s
                  current_user
      end

      render json: { errors: [ "Teacher not found" ] }, status: :not_found unless @teacher
    end

    def authorize_admin!
      return if current_user.admin?
      render json: { errors: [ "Unauthorized" ] }, status: :forbidden
    end

    def permitted_teacher_params
      if params.key?(:teacher)
        params.require(:teacher).permit(
          :name,
          :email,
          :password,
          :password_confirmation,
          :subject
        )
      else
        params.permit(
          :name,
          :email,
          :password,
          :password_confirmation,
          :subject
        )
      end
    end

    def teacher_hash(teacher, include_students: false)
      hash = {
        id: teacher.id,
        name: teacher.name.presence || teacher.email,
        email: teacher.email,
        subject: teacher.subject
      }

      if include_students
        hash[:students] = teacher.students.select(:id, :name).map do |student|
          {
            id: student.id,
            name: student.name
          }
        end
      end
      hash
    end
  end
end
