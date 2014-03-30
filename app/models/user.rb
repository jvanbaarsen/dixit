Clearance::User::Validations.module_eval do
  included do
    validates :email,
          presence: true,
          uniqueness: { allow_blank: true },
          unless: :email_optional?
    validates :email, email: { strict_mode: true }, if: -> {email.present?}
    validates :password, presence: true, unless: :skip_password_validation?
  end
end

class User < ActiveRecord::Base
  include Clearance::User

  validates :name, presence: true
end

