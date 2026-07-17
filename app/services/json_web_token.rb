class JsonWebToken
  SECRET = Rails.application.secret_key_base || ENV['SECRET_KEY_BASE'] || 'fallback_secret'

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
    nil
  end
end
