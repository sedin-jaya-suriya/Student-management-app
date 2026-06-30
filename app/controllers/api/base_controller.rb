module Api
  class BaseController < ActionController::API
    before_action :authorize_request

    attr_reader :current_user

    private

    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header.present?
      decoded = JsonWebToken.decode(header)
      if decoded && decoded[:user_id]
        @current_user = User.find_by(id: decoded[:user_id])
      end
      render json: { errors: ['Not Authorized'] }, status: :unauthorized unless @current_user
    end

    def render_unprocessable(resource)
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
