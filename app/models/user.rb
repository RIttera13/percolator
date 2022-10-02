class User < ApplicationRecord
  
  validates_presence_of  :first_name, :uniqueness => {:allow_blank => false}
  validates :first_name, uniqueness: true
  validates_presence_of  :last_name, :uniqueness => {:allow_blank => false}
  validates :last_name, uniqueness: true
  validates_presence_of  :username, :uniqueness => {:allow_blank => false}
  validates :username, uniqueness: true
  validates_presence_of  :email, :uniqueness => {:allow_blank => false}
  validates :email, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :jwt_authenticatable, :registerable,
         jwt_revocation_strategy: JwtDenylist
end
