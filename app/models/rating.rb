class Rating < ApplicationRecord

  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id', counter_cache: true #Optimized by useing counter_cache for user post count
  belongs_to :rater, :class_name => 'User', :foreign_key => 'rater_id'

  validates :rating, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 5}

  class << self
    def in_order
      order(rated_at: :asc)
    end

    def recent(n)
      in_order.endmost(n)
    end

    def endmost(n)
      all.only(:order).from(all.reverse_order.limit(n), table_name)
    end
  end
end
