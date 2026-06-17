class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters,
                if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound,
              with: :record_not_found

  allow_browser versions: :modern
  stale_when_importmap_changes

  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.admin?
    return teacher_dashboard_path if resource.teacher?
    root_path
  end

  def require_admin!
    redirect_to root_path,alert: "Access denied." unless current_user.admin?
  end

  def require_teacher!
    redirect_to root_path,alert: "Access denied." unless current_user.teacher?
  end

  def record_not_found
    redirect_to students_path,alert: "Student not found or access denied."
  end
end