class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters,
                if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound,
              with: :record_not_found

  allow_browser versions: :modern

  stale_when_importmap_changes

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,keys: [:role])
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_dashboard_path
    else
      teacher_dashboard_path
    end
  end

  private

  def record_not_found
    redirect_to students_path,
                alert: "Student not found or access denied."
  end
end