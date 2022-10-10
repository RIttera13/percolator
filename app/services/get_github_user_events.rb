class GetGithubUserEvents
  include HTTParty

  # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
  def self.call(current_user, page_number = 1)
    github_username = current_user.github_username
    begin
      # Set the API endpoint injecting the github user name.
      uri = "https://api.github.com/users/#{github_username}/events/public"

      # Configure the headers and query to allow recursive calls for more objects.
      request_settings = {headers: {}}
      request_settings[:headers] = { "Content-Type" => "application/vnd.github+json" }
      request_settings[:query] = { "per_page" => 100, "page" => page_number }

      # Send API request and access the returned data.
      request = HTTParty.get("#{uri}", :headers => request_settings[:headers], :query => request_settings[:query])

      # Return if the Github username returns not found.
      if request.message == "Not Found" || request.message.include?("rate limit exceeded")
        return [{ error: true, message: request.message }]
      end
      # Check the number of objects returned to determin if there may be more pages.
      if request.count < 100
        github_events = [{ page: page_number }, { last_page: true }]
      else
        github_events = [{ page: page_number }, { last_page: false }]
      end
binding.pry
      # Loop over the returned data, check each to see the type of event, and add it to the object to return.
      request.each do |event|
        event_type = ""
        commit_count = 0
        if (event["type"] == "PullRequestEvent") && (event["payload"]["action"] == "opened")
          event_type = "Opened New Pull Request"
        elsif (event["type"] == "PullRequestEvent") && (event["payload"]["action"] == "closed")
          event_type = "Merged Pull Request"
        elsif (event["type"] == "CreateEvent") && (event["payload"]["ref_type"] == "repository")
          event_type = "Created New Repository"
        elsif (event["type"] == "CreateEvent") && (event["payload"]["ref_type"] == "branch")
          event_type = "Created New Branch"
        elsif event["type"] == "PushEvent"
          event_type = "Pushed Commits to Branch"
          commit_count = event["payload"]["commits"].count
        else
          next
        end

        # Check response and standardize for presentation to requestor.
        repo = event["repo"]["name"].present? ? event["repo"]["name"] : "N/A"
        branch = event["payload"]["ref"].present? ? event["payload"]["ref"].split("/").last : "N/A" # This is not ideal, but works for now.
        pull_request_number = event["payload"]["number"].present? ? event["payload"]["number"] : nil

        new_event_timeline = EventTimeline.create(user_id: current_user.id)
        if GithubEvent.create(github_event_type: event_type, repository: repo, branch: branch, pull_request_number: pull_request_number, commit_count: commit_count, timestamp: event["created_at"], event_timeline_id: new_event_timeline.id, user_id: current_user.id).save
          new_event_timeline.update(created_at: event["created_at"])
        else
          new_event_timeline.delete
        end
      end

      return github_events
    rescue => error
      return error
    end
  end
end
