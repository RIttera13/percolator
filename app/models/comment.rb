class Comment < ApplicationRecord

  validates_presence_of :message
  validates_presence_of :commented_at
  validates_presence_of :post_id
  validates_presence_of :user_id

  belongs_to :user
  belongs_to :post

end
