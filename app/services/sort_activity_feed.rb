class SortActivityFeed
  def self.call(current_user, page_number = 1)

    # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
    user_activites = []

    # Check for the presnce of date before adding the record to the array
    if current_user.passed_four_stars.present?
      user_activites += [Activity.new("average_rating", {average_rating: current_user.average_rating.to_f.round(1)}, current_user.passed_four_stars)]
    end

    user_activites += Post.where(user_id: current_user.id).order('posted_at DESC').reject { |s| s.posted_at == nil }.map do |post|
      Activity.new("post", {title: post.title, comment_count: post.comments.count}, post.posted_at)
    end

    user_activites += Comment.where(user_id: current_user.id).order('commented_at DESC').reject { |s| s.commented_at == nil }.map do |comment|
      Activity.new("comment", {post_owner_name: comment.post.user.name, post_owner_average_rating: comment.post.user.average_rating.to_f.round(1)}, comment.commented_at)
    end

    user_activites += Rating.where(user_id: current_user.id).order('rated_at DESC').reject { |s| s.rated_at == nil }.map do |rating|
      Activity.new("rating", {rater_name: rating.rater.name, rating: rating.rating}, rating.rated_at)
    end

    # Use a resue block with outside API calls so that we can continue to serve other data if the API has errors.
    begin
      # Get all available "github_events" by looping the call until there are no more pages
      github_events = []
      call_count = 1
      loop do
        respons = GetGithubUserEvents.call(current_user.github_username, call_count)
        if respons.first[:error].present?
          break
        else
          call_count += 1
          github_events += respons
          # Check if the respons is the last page from github to break the loop
          if respons.find{ |h| h[:last_page] }.values.first
            break
          end
        end
      end

      # Remove everything except the github event data
      github_events.delete_if {|a| a[:last_page] || a[:page] }
      user_activites += github_events.reject { |s| s[:timestamp] == nil }.map do |github_event|
        Activity.new("github", {event_type: github_event[:type], repository: github_event[:repository], branch: github_event[:brach], pull_request_number: github_event[:pull_request_number]}, github_event[:timestamp].to_datetime)
      end
    rescue => error
      puts error
    end

    # Sort the records by date and set to descending order
    sorted_activities = user_activites.sort_by(&:date).reverse

    # Get the starting activity index number
    activity_number_start = (50 * page_number) - 49

    # Send activities in groups of 25
    limited_activities = sorted_activities[(activity_number_start - 1)..(activity_number_start + 48)]

    # Get the starting activity index number, ensure there are activities to return to avoid errors
    if limited_activities.nil?
      activity_number_end = nil
    else
      activity_number_end = activity_number_start + (limited_activities.count - 1)
    end

    @activities = {activities: limited_activities, page_number: page_number, activity_number_start: activity_number_start, activity_number_end: activity_number_end}
  end
end
