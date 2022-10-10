class AddPassedFourStarsToEventTimeline < ActiveRecord::Migration[6.0]
  def change
    add_column :event_timelines, :passed_four_stars, :boolean
  end
end
