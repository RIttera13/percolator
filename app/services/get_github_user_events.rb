class GetGithubUserEvents
  include HTTParty

  def self.call(github_username)
    begin
      uri = "https://api.github.com/users/#{github_username}/events/public"
      request_settings = {headers: {}}
      request_settings[:headers] = {"Content-Type" => "application/vnd.github+json"}

      request = HTTParty.get("#{uri}", :headers => request_settings[:headers])

      return request
    rescue => error
      return error
    end
  end
end
