class StudentsController < ApplicationController
  skip_forgery_protection
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
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @student = Student.new(student_params)

    if current_user.teacher?
      @student.teacher = current_user
    end

    if @student.save
      redirect_to students_path, notice: "Student was created successfully.", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @student.update(student_params)
      redirect_to students_path,
                  notice: "Student updated successfully.",
                  status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_path, notice: "Student deleted successfully.", status: :see_other }
      format.turbo_stream
    end
  end

  def remove_profile_photo
    @student.profile_photo.purge
    redirect_to @student, notice: "Profile photo deleted successfully.", status: :see_other
  end

  def remove_document
    document = @student.documents.find(params[:attachment_id])
    document.purge

    redirect_to @student, notice: "Document deleted successfully.", status: :see_other
  end

  def generate_report
    begin
      StudentMailer.report_card(@student).deliver_later
    rescue => e
      Rails.logger.error "Error generating report for Student #{@student.id}: #{e.message}"
    end

    redirect_to @student, notice: "✅ Successfully generated document.", status: :see_other
  end

  def generate_all_reports
    begin
      student_scope.find_each do |student|
        StudentMailer.report_card(student).deliver_later
      end
    rescue => e
      Rails.logger.error "Error enqueuing report generation: #{e.message}"
    end

    redirect_to students_path, notice: "✅ Successfully generated document.", status: :see_other
  end

  def download_report
    begin
      pdf_data = ReportCardGenerator.call(@student)
      send_data pdf_data,
                filename: "ReportCard_#{@student.id}.pdf",
                type: "application/pdf"
    rescue => e
      Rails.logger.error "Failed to download report for Student #{@student.id}: #{e.message}"
      redirect_to @student, alert: "Failed to download the report card.", status: :see_other
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
      documents: [],
      assignments: []
    )
  end
end
