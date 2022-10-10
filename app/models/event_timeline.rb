class EventTimeline < ApplicationRecord
  belongs_to :user
  has_one :post
  has_one :comment
  has_one :rating
  has_one :github_event
end
