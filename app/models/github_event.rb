class GithubEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event_timeline
end
