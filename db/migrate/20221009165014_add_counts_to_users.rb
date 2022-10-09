class AddCountsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :comments_count, :integer
    add_column :users, :posts_count, :integer
    add_column :users, :ratings_count, :integer
  end

  # Update counts on for Users
  # User.find_each do |user|
  #   User.reset_counters(user.id, :ratings)
  #   User.reset_counters(user.id, :posts)
  #   User.reset_counters(user.id, :comments)
  # end

end
