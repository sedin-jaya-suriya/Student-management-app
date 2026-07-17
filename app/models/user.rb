require 'devise' unless defined?(Devise)

class User < ApplicationRecord
  if defined?(Devise)
    devise :database_authenticatable,
           :registerable,
           :recoverable,
           :rememberable,
           :validatable,
           :jwt_authenticatable,
          jwt_revocation_strategy: JwtDenylist
  end

  has_many :students,
           foreign_key: :teacher_id,
           dependent: :destroy

  enum :role, {
    admin: "admin",
    teacher: "teacher"
  }
end