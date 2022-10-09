class AddCommentsCounterToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :comments_count, :integer
  end

  # Update counts for Posts
  # Post.find_each do |post|
  #   Post.reset_counters(post.id, :comments)
  # end
end
