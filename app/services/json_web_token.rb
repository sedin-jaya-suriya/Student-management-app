class JsonWebToken
  def self.secret
    Rails.application.credentials.devise_jwt_secret || Rails.application.secret_key_base || ENV["SECRET_KEY_BASE"] || "fallback_secret"
  end

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    payload[:jti] ||= SecureRandom.uuid
    JWT.encode(payload, secret)
  end

  def self.decode(token)
    body = JWT.decode(token, secret)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    nil
  end
end
