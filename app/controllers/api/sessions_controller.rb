module Api
  class SessionsController < ActionController::API
    def create
      user = User.find_for_authentication(email: params[:email])
      if user&.valid_password?(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token }, status: :created
      else
        render json: { errors: ['Invalid email or password'] }, status: :unauthorized
      end
    end
  end
end
