class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable, :registerable, jwt_revocation_strategy: JwtDenylist

  validates_presence_of :name
  validates_presence_of :email
  validates :email, uniqueness: true

  has_many :posts
  has_many :ratings

  # Generate JWT token to help get the current user_id from auth token used in api requests.
  def generate_jwt
    JWT.encode({ id: id, exp: 1.days.from_now.to_i }, Rails.application.credentials.jwt[:jwt_secret_key])
  end

end
