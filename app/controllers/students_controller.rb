class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin?
      @students = Student.all
    else
      @students = current_user.students
    end

    if params[:search].present?
      @students = @students.where(
        "name LIKE ? OR email LIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%"
      )
    end

    if params[:course].present? && params[:course] != "All"
      @students = @students.where(course: params[:course])
    end
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)

    if current_user.teacher?
      @student.teacher = current_user
    end

    if @student.save
      redirect_to @student
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path
  end

  private

  def set_student
    if current_user.admin?
      @student = Student.find(params[:id])
    else
      @student = current_user.students.find(params[:id])
    end
  end

  def student_params
    params.require(:student).permit(
        :name,
        :email,
        :age,
        :course,
        :city,
        :marks,
        :teacher_id
    )
    end
end