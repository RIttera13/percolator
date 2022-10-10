class Post < ApplicationRecord

  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :posted_at
  validates_presence_of :user_id

  belongs_to :user, counter_cache: true #Optimized by useing counter_cache for user post count
  has_many :comments, dependent: :destroy
  belongs_to :event_timeline

end
