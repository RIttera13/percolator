class User < ApplicationRecord

  validates_presence_of :name
  validates :name, uniqueness: true
  validates_presence_of :email
  validates :email, uniqueness: true

  has_many :posts

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         jwt_revocation_strategy: JwtDenylist

  def generate_jwt
    JWT.encode({ id: id, exp: 1.days.from_now.to_i }, Rails.application.credentials.jwt[:jwt_secret_key])
  end

end
