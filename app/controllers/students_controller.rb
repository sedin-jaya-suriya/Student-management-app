class StudentsController < ApplicationController
  before_action :set_student, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :remove_profile_photo,
    :remove_document
  ]

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
      redirect_to @student, notice: "Student created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student, notice: "Student updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path, notice: "Student deleted successfully."
  end

  def remove_profile_photo
    @student.profile_photo.purge

    redirect_to @student,
                notice: "Profile photo deleted successfully."
  end

  def remove_document
    document = @student.documents.find(params[:attachment_id])
    document.purge

    redirect_to @student,
                notice: "Document deleted successfully."
  end

  private

  def student_scope
    current_user.admin? ? Student.all : current_user.students
  end

  def set_student
    @student = student_scope.find(params[:id])
  end

  def student_params
    params.require(:student).permit(
      :name,
      :email,
      :age,
      :course,
      :city,
      :marks,
      :teacher_id,
      :profile_photo,
      documents: []
    )
  end
end