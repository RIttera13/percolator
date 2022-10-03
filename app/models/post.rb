class Post < ApplicationRecord

  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :posted_at
  validates_presence_of :user_id

  belongs_to :user
  has_many :comments

end
