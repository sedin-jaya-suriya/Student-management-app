class StudentsController < ApplicationController
  before_action :set_student, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :remove_profile_photo,
    :remove_document,
    :generate_report,
    :download_report
  ]

  helper_method :student_scope

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
      StudentMailer.welcome_email(@student).deliver_now
      StudentMailer.teacher_assigned(@student).deliver_now

      if @student.teacher.present?
        TeacherMailer.new_student(@student).deliver_now
      end

      if @student.documents.attached?
        @student.documents.each do |document|
          StudentMailer.assignment_submitted(@student, document).deliver_now
        end
      end

      respond_to do |format|
        format.html { redirect_to @student, notice: "Student created successfully." }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_student",
            partial: "form",
            locals: { student: @student }
          )
        end
      end
    end
  end

  def update
    old_marks = @student.marks
    old_teacher = @student.teacher_id

    if @student.update(student_params)
      if old_marks != @student.marks
        StudentMailer.marks_published(@student).deliver_now
      end

      if old_teacher != @student.teacher_id
        StudentMailer.teacher_assigned(@student).deliver_now
        TeacherMailer.new_student(@student).deliver_now
      end

      if params.dig(:student, :documents).present?
        @student.documents.last(params[:student][:documents].count).each do |document|
          StudentMailer.assignment_submitted(@student, document).deliver_now
        end
      end

      respond_to do |format|
        format.html { redirect_to @student, notice: "Student updated successfully." }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_path, notice: "Student deleted successfully." }
      format.turbo_stream
    end
  end

  def remove_profile_photo
    @student.profile_photo.purge
    redirect_to @student, notice: "Profile photo deleted successfully."
  end

  def remove_document
    document = @student.documents.find(params[:attachment_id])
    document.purge

    redirect_to @student, notice: "Document deleted successfully."
  end

  def generate_report
    ReportCardGenerationJob.perform_later(@student.id)
    redirect_to @student, notice: "Report generation has been queued successfully."
  end

  def generate_all_reports
    student_scope.find_each do |student|
      ReportCardGenerationJob.perform_later(student.id)
    end
    redirect_to students_path, notice: "Report generation for all students has been queued successfully."
  end

  def download_report
    if @student.report_card.attached?
      send_data @student.report_card.download,
                filename: "ReportCard_#{@student.id}.pdf",
                type: "application/pdf"
    else
      redirect_to @student, alert: "Report card not found."
    end
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
