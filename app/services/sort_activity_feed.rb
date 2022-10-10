class SortActivityFeed
  def self.call(current_user, page_number = 1)

    # verify page number is integer
    page_number = page_number.present? ? page_number.to_i : 1

    offset = (page_number - 1)
    if offset <= 0
      offset = 0
      page_number = 1
    end

    # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
    user_activites = []

    # Use a resue block with outside API calls so that we can continue to serve other data if the API has errors.
    begin
      # Get all available "github_events" by looping the call until there are no more pages
      call_count = 1
      loop do
        if call_count == 1
          GithubEvent.where(user_id: current_user).delete_all
        end

        respons = GetGithubUserEvents.call(current_user, call_count)
        if respons.first[:error].present?
          break
        else
          call_count += 1
          # Check if the respons is the last page from github to break the loop
          if respons.find{ |h| h[:last_page] }.values.first
            break
          end
        end
      end

      # Remove everything except the github event data
      github_events.delete_if {|a| a[:last_page] || a[:page] }
      user_activites += github_events.reject { |s| s[:timestamp] == nil }.map do |github_event|
      end
    rescue => error
      puts error
    end

    user_activites += current_user.event_timelines.order('created_at DESC').limit(50).offset(offset).map.with_index do |event, index|
      if event.passed_four_stars?
        Activity.new("passed_four_stars", { average_rating: current_user.average_rating.to_f.round(1) }, current_user.passed_four_stars)
      elsif event.post.present?
        Activity.new("post", { title: event.post.title, comment_count: event.post.comments.size }, event.post.posted_at)
      elsif even.comment.present?
        Activity.new("comment", { post_owner_name: event.comment.post.user.name, post_owner_average_rating: event.comment.post.user.average_rating.to_f.round(1) }, event.comment.commented_at)
      elsif event.rating.present?
        Activity.new("rating", { rater_name: event.rating.rater.name, rating: event.rating.rating }, event.rating.rated_at)
      elsif event.rating.present?
        Activity.new("github", { event_type: event.github_event[:type], repository: event.github_event[:repository], branch: event.github_event[:brach], pull_request_number: event.github_event[:pull_request_number], commit_count: event.github_event[:commit_count] }, event.github_event[:timestamp].to_datetime)
      end

    end

    # Sort the records by date and set to descending order
    sorted_activities = user_activites.sort_by(&:date).reverse

    # Get the starting activity index number
    activity_number_start = (50 * page_number) - 49

    # Get the end activity index number
    activity_number_end = activity_number_start + (sorted_activities.count - 1)

    binding.pry

    @activities = { activities: sorted_activities, page_number: page_number, activity_number_start: activity_number_start, activity_number_end: activity_number_end }
  end
end
