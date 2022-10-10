class CreateEventTimelines < ActiveRecord::Migration[6.0]
  def change
    create_table :event_timelines do |t|
      t.belongs_to :user
      t.boolean :passed_four_stars
      t.datetime :created_at
    end
  end
end
