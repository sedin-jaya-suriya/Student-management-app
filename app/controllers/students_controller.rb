class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
    @students = student_scope
    @students = @students.search(params[:search]) if params[:search].present?
    @students = @students.by_course(params[:course]) if params[:course].present?
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
      redirect_to @student,notice: "Student created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student,notice: "Student updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path,notice: "Student deleted successfully."
  end

  private

  def student_scope
    current_user.admin? ? Student.all : current_user.students
  end

  def set_student
    @student = student_scope.find(params[:id])
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
    params.require(:student).permit(permitted)
  end
end