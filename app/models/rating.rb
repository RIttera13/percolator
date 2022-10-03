class Rating < ApplicationRecord

  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :rater, :class_name => 'User', :foreign_key => 'rater_id'

  validates :rating, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5}

end
