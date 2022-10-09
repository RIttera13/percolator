class Post < ApplicationRecord

  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :posted_at
  validates_presence_of :user_id

  belongs_to :user, counter_cache: true #Optimized by useing counter_cache for user post count
  has_many :comments

  class << self
    def in_order
      order(posted_at: :asc)
    end

    def recent(n)
      in_order.endmost(n)
    end

    def endmost(n)
      all.only(:order).from(all.reverse_order.limit(n), table_name)
    end
  end
end
