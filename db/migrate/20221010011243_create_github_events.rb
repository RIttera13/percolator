class CreateGithubEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :github_events do |t|
      t.string :type
      t.string :repository
      t.string :branch
      t.integer :pull_request_number
      t.datetime :timestamp
      t.belongs_to :event_timeline
    end
  end
end
