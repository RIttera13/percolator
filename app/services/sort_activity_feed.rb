class SortActivityFeed
  def self.call(current_user, page_number = 0)

    # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
    limit = 25
    user_activites = []

    # Check for the presnce of date before adding the record to the array
    if current_user.passed_four_stars.present?
      user_activites += [Activity.new("average_rating", {average_rating: current_user.average_rating.to_f}, current_user.passed_four_stars)]
    end

    user_activites += Post.where(user_id: current_user.id).order('posted_at DESC').limit(limit).reject { |s| s.posted_at == nil }.map do |post|
      Activity.new("post", {title: post.title, comment_count: post.comments.count}, post.posted_at)
    end

    user_activites += Comment.where(user_id: current_user.id).order('commented_at DESC').limit(limit).reject { |s| s.commented_at == nil }.map do |comment|
      Activity.new("comment", {post_owner_name: comment.post.user.name, post_owner_average_rating: comment.post.user.average_rating.to_f}, comment.commented_at)
    end

    user_activites += Rating.where(user_id: current_user.id).order('rated_at DESC').limit(limit).reject { |s| s.rated_at == nil }.map do |rating|
      Activity.new("rating", {rater_name: rating.rater.name, rating: rating.rating}, rating.rated_at)
    end

    user_activites += GetGithubUserEvents.call(current_user.github_username).reject { |s| s[:timestamp] == nil }.map do |github_event|
      Activity.new("github", {type: github_event[:type], repository: github_event[:repository], branch: github_event[:brach], pull_request_number: github_event[:pull_request_number]}, github_event[:timestamp].to_datetime)
    end
      binding.pry
    # Sort the records by date and set to descending order
    sorted_activities = user_activites.sort_by(&:date).reverse

    # 10 most recent elements across all models
    @activities = sorted_activities[0..(limit-1)]
  end
end
