class CreateGithubEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :github_events do |t|
      t.string :github_event_type
      t.string :repository
      t.string :branch
      t.integer :pull_request_number
      t.integer :commit_count
      t.datetime :timestamp
      t.belongs_to :event_timeline
      t.belongs_to :user
    end
  end
end
