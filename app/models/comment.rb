class Comment < ApplicationRecord

  validates_presence_of :message
  validates_presence_of :commented_at
  validates_presence_of :post_id
  validates_presence_of :user_id

  belongs_to :user, counter_cache: true #Optimized by useing counter_cache for user comment count
  belongs_to :post, counter_cache: true #Optimized by useing counter_cache for post comment count
  belongs_to :event_timeline

end
