class EventTimeline < ApplicationRecord
  belongs_to :user
  has_one :post, dependent: :destroy
  has_one :comment, dependent: :destroy
  has_one :rating, dependent: :destroy
  has_one :github_event, dependent: :destroy
end
