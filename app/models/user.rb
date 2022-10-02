class User < ApplicationRecord


  validates_presence_of :name
  validates :name, uniqueness: true
  validates_presence_of :email
  validates :email, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         jwt_revocation_strategy: JwtDenylist

end
