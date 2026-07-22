module Api
  class BaseController < ActionController::API
    include ActionController::MimeResponds
    include Devise::Controllers::Helpers

    before_action :authenticate_api_user!

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { errors: [ e.message ] }, status: :not_found
    end

    respond_to :json

    private

    # Custom authenticator that reads the JWT Bearer token from the
    # Authorization header and authenticates via devise-jwt.
    # This is completely separate from the web UI cookie session.
    def authenticate_api_user!
      token = extract_token_from_header
      if token.blank?
        return render json: { error: "Unauthorized. Please provide a Bearer token in the Authorization header." }, status: :unauthorized
      end

      begin
        payload = decode_jwt_token(token)
        user_id = payload["sub"]
        jti     = payload["jti"]
        exp     = payload["exp"]

        # Check expiry
        if exp.present? && Time.at(exp.to_i) < Time.now
          return render json: { error: "Token has expired. Please login again." }, status: :unauthorized
        end

        # Check revocation (denylist)
        if JwtDenylist.exists?(jti: jti)
          return render json: { error: "Token has been revoked. Please login again." }, status: :unauthorized
        end

        @current_api_user = User.find(user_id)
      rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
        render json: { errors: [ "Invalid token" ] }, status: :unauthorized
      end
    end

    def current_user
      @current_api_user
    end

    def extract_token_from_header
      auth_header = request.headers["Authorization"]
      return nil unless auth_header&.start_with?("Bearer ")
      auth_header.split(" ", 2).last
    end

    def decode_jwt_token(token)
      secret = Rails.application.credentials.devise_jwt_secret || Rails.application.secret_key_base
      decoded = JWT.decode(token, secret, true, algorithm: "HS256")
      decoded.first
    end
  end
end
