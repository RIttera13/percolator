class Rating < ApplicationRecord

  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id', counter_cache: true #Optimized by useing counter_cache for user post count
  belongs_to :rater, :class_name => 'User', :foreign_key => 'rater_id'
  belongs_to :event_timeline

  validates :rating, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5}

end
