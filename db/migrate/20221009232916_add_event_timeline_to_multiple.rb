class AddEventTimelineToMultiple < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :event_timeline, foreign_key: true
    add_reference :comments, :event_timeline, foreign_key: true
    add_reference :ratings, :event_timeline, foreign_key: true
  end
end
