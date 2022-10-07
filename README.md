# Percolator

Percolator is a backend coding challenge to create a web service API that will provide data to a hypothetical social media application with mobile and web clients. The requirements will be outlined at the bottom.

Installation
--------

* Ruby version: '2.5.8'

 --_Selected because it is the current working version for my other projects. This required less time to set up._--

* Rails version: '~> 6.0.4', '>= 6.0.4.1' -- Tested with Rails 6.0.6 --

* PostgreSQL 12  -- _Tested with PostgreSQL 12_ --


* PostgreSQL will require a development user:
  - Install and start a local PostgresSQL server with default settings and ports
  - `sudo su - postgres`
  - `psql`
  - `CREATE ROLE percolator WITH LOGIN CREATEDB ENCRYPTED PASSWORD 'percolator';`

Start the application
--------

 - After installing Ruby, Rails, and starting a PostgreSQL server:
 - Add the following string to the master.key file: `b8cd0eda97fb5ea05ee1ee05ace68318` We would never usually publish this key, but this is not a production application.

 _run the following from the applications root directory:_
 - `bundle install`
 - `rake db:create`
 - `rake db:migrate`
 - `rale db:seed` _(For quicker testing, adjust the counts lower in the seed file)_
 - `rails server`

 _This starts the rails server and should make the API available on `http://localhost:3000`. For production we would make this https and set allowed hosts for better security._

# Test #
Run the test suite by entering the command below in the application's root directory.
* `rails test`

# Services #
No other services are required but could be easily added to provide scheduled jobs.

# API endpoints and usage

User
-------
 - Create a new user _Sign Up_
    - Header "Content-Type: application/json"
    - Data includes: { user: { name: "`string`", github_username: "`string`", email: "`string`",       password: "`string`" } }
    - POST `http://localhost:3000/users`
    - Successful respons will include `status: 200, message:"Welcome to Percolator."`

 - User log in _Sign In_
   - Header "Content-Type: application/json"
   - Data includes: { user: { email: "`string`", password: "`string`" } }
   - POST `http://localhost:3000/users/sign_in`
   - Successful respons will include `status: 200` and an `Authorization: Bearer token` to be        used in authenticating future calls.

 - User log out _Sign Out_
   - DELETE `http://localhost:3000/users/sign_out`

 - User data _User Profile_
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - GET `http://localhost:3000/current_user`
   - Successful response will include `status: 200` and a JSON containing:
    - Top-level: `{ "user":{} }`
    - `"id":` integer
    - `"name":` string
    - `"github_username":` string
    - `"email":` string
    - `"average_rating":` float
    - `"passed_four_stars":` string 'date_time'
    - `"registered_at":` string 'date_time'
    - `"created_at":` string 'date_time'
    - `"updated_at":` string 'date_time'


Post
-------
 - Create a new Post
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"post": {"title": string, "body": text}`
   - POST `http://localhost:3000/posts`
   - Successful respons will include `status: 200, {"message":"Your post has been created. ID: 'post_id'"}`

 - Update a Post
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"post": {"title": string, "body": text}`
   - PATCH `http://localhost:3000/posts/'post_id'`
   - Successful respons will include `status: 200, {"message":"Your post has been updated. ID: 'post_id'"}`

 - Delete a Post
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`    
   - DELETE `http://localhost:3000/posts/'post_id'`
   - Successful respons will include `status: 200, {"message":"Your post has been deleted. ID: 'post_id'"}`

 - Get a Post
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`  
   - GET `http://localhost:3000/posts/'post_id'`
   - Successful response will include `status: 200` and a JSON containing:
    - Top-level: `{ "post": {} }`
    - `"id":` integer
    - `"title":` string
    - `"body":` text
    - `"user_id":` integer
    - `"user_name":` string
    - `"user_rating":` float
    - `"comment_count":` integer
    - `"posted_at":` string 'date_time'
    - `"created_at":` string 'date_time'
    - `"updated_at":` string 'date_time'

  - Get all Posts
  _This is a recursive endpoint. You will receive data in chunks of **25 comments**. Use the `page_number:` in the response to know which page to request next._
    - Header "Content-Type: application/json"
    - Header `Authorization: Bearer token`
    - Data includes: `{"post": {"page": integer}`
    - GET `http://localhost:3000/posts
    - Successful response will include `status: 200` and a JSON containing:
    - `"message":` string  "Posts 'starting number' - 'ending number'" e.x. "Posts 1 - 25"
    - `"page_number":` integer
    - `"posts":` [{data}]
      - `"id":` integer
      - `"title":` string
      - `"body":` text
      - `"user_id":` integer
      - `"user_name":` string
      - `"user_rating":` float
      - `"comment_count":` integer
      - `"posted_at":` string 'date_time'
      - `"created_at":` string 'date_time'
      - `"updated_at":` string 'date_time'

 - Get Comments for a Post
 _This is a recursive endpoint. You will receive data in chunks of **25 comments**. Use the `page_number:` in the response to know which page to request next._
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"post": {"post_id": integer, "page": integer}}`
   - GET `http://localhost:3000/get_comments_for_post
   - Successful response will include `status: 200` and a JSON containing:
    - `"message":` string  "Comments 'starting number' - 'ending number'" e.x. "Comments 1 - 25"
    - `"post_id":` integer
    - `"page_number":` integer
    - `"comments":` [{data}]
         - `"id":` integer
         - `"message":` text
         - `"commented_at":` string 'date_time'
         - `"user_name":` string
         - `"user_average_rating":` float

Comment
-------
 - Create a new Comment
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"comment": {"message": text, "post_id": integer}`
   - POST `http://localhost:3000/comments`
   - Successful response will include `status: 200, {"message":"Your comment has been created. ID:    'comment_id'"}`

 - Update a Comment
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"comment": {"message": text}`
   - PATCH `http://localhost:3000/comments/'comment_id'`
   - Successful response will include `status: 200, {"message":"Your comment has been updated. ID:    'comment_id'"}`

 - Delete a Comment
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`    
   - DELETE `http://localhost:3000/comments/'comment_id'`
   - Successful response will include `status: 200, {"message":"Your comment has been deleted. ID:    'comment_id'"}`

 - Get a Comment
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`  
   - GET `http://localhost:3000/comments/'comment_id'`
   - Successful response will include `status: 200` and a JSON containing:
    - Top-level: `{ "comment": {} }`
    - `"id":` integer
    - `"message":` text
    - `"user_id":` integer
    - `"post_id":` integer
    - `"user_name":` string
    - `"user_average_rating":` float
    - `"commented_at":` string 'date_time'
    - `"created_at":` string 'date_time'
    - `"updated_at":` string 'date_time'

  - Get all Comments
   _This is a recursive endpoint. You will receive data in chunks of **25 comments**. Use the `page_number:` in the response to know which page to request next._
    - Header "Content-Type: application/json"
    - Header `Authorization: Bearer token`
    - Data includes: `{"comment": {"page": integer}`
    - GET `http://localhost:3000/comments
    - Successful response will include `status: 200` and a JSON containing:
    - `"message":` string  "Comment 'starting number' - 'ending number'" e.x. "Comments 1 - 25"
    - `"page_number":` integer
    - `"comments":` [{data}]
      - `"id":` integer
      - `"message":` text
      - `"user_id":` integer
      - `"post_id":` integer
      - `"user_name":` string
      - `"user_average_rating":` float
      - `"commented_at":` string 'date_time'
      - `"created_at":` string 'date_time'
      - `"updated_at":` string 'date_time'


Rating
-------
 - Create a new Rating
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"rating": {"rating": integer, "user_id": integer}`
   - POST `http://localhost:3000/ratings`
   - Successful response will include `status: 200, {"message":"You rated 'user_name' a 'rating'      ."}`

 - Update a Rating
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"rating": {"rating": integer}`
   - PATCH `http://localhost:3000/ratings/'rating_id'`
   - Successful response will include `status: 200, {"message":"Your rating has been updated. ID:      'rating_id'"}`

 - Delete a Rating
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`    
   - DELETE `http://localhost:3000/ratings/'rating_id'`
   - Successful response will include `status: 200, {"message":"Your rating has been deleted. ID:      'rating_id'"}`

 - Get a Rating
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - GET `http://localhost:3000/ratings/'rating_id'`
   - Successful response will include `status: 200` and a JSON containing:
    - Top-level: `{ "rating": {} }`
    - `"id":` integer
    - `"user_id":` integer
    - `"rater_id":` integer
    - `"user_name":` string
    - `"rating":` float
    - `"rated_at":` string 'date_time'
    - `"created_at":` string 'date_time'
    - `"updated_at":` string 'date_time'

 - Get all Rating
 _This is a recursive endpoint. You will receive data in chunks of **25 comments**. Use the `page_number:` in the response to know which page to request next._
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data includes: `{"rating": {"rating": integer}`
   - GET `http://localhost:3000/ratings
   - Successful response will include `status: 200` and a JSON containing:
   - `"message":` string  "Ratings 'starting number' - 'ending number'" e.x. "Comments 1 - 25"
   - `"page_number":` integer
   - `"ratings":` [{data}]
     - `"id":` integer
     - `"user_id":` integer
     - `"rater_id":` integer
     - `"user_name":` string
     - `"rating":` float
     - `"rated_at":` string 'date_time'
     - `"created_at":` string 'date_time'
     - `"updated_at":` string 'date_time'

Activity Feed (a.k.a Timeline)
-------

_The activity feed is a recursive endpoint. You will receive data in chunks of **50 activities**. Use the `page_number:` in the response to know which page to request next._

 - Get an Activity Feed
   - Header "Content-Type: application/json"
   - Header `Authorization: Bearer token`
   - Data REQUIRES: `{"activity_feed": { "page": integer}`  _(If no page is given, the default will be      1. You can find the page number in the current response to know what page to ask for next.)_
   - GET `http://localhost:3000/activity_feed'`
   - Successful response will include `status: 200` and a JSON containing:
    - `"message":` "Activities 'starting number' - 'ending number'" e.x. "Activities 1 - 50"
    - `"page_number":` integer
    - `"activity_list":` [data]
        -   {"type": "", "data": {}, "date": ""}
         - `"type":` string `post`, `comment`, `rating`, `passed_four_stars`, `github`
         - `"post":` {`"title":` string,`"comment_count":` integer}
         - `"comment":` {`"post_owner_name":` string, `"post_owner_average_rating":` float}
         - `"rating":` {`rater_name:` string, `rating:` float}
         - `"passed_four_stars":` {`average_rating:` float}
         - `"github":` {`"event_type":` string, `"repository":` string, `"branch":` string, `"pull_request_number":` integer, `"commit_count:"` string}
         - `"event_type":` string `Opened New Pull Request`, `Merged Pull Request`, `Created New Repository`, `Created New Branch`, `Pushed Commits to Branch`
         - `"date":` string 'date_time'

# Big Thank You!!! #
 * Rails Devise Team
 * HTTParty Team
 * Pry-Rails Team

There are many more awesome devs out there to thank for their amazing support of the Ruby On Rails platform and community. Sincerely, thank you.

# Challenge Requirements

The app:
--------

* Has Users
* Users can create posts with a title and a body.
* Users can create comments on posts (both other people’s posts and their own).
* Users can “rate” any other user between 1 and 5 stars (inclusive).
* A User has a rating, which is an average of the ratings they’ve received from other users.
* A Users rating will be displayed along with their name on posts and comments.
* Each user has a timeline, which is an “infinite scroll” activity feed of things the user has done with the most recent activities at the top.

* A User’s timeline should include:
 -  When they create a post
 -  When they comment on a post
 -  When they surpass a 4-star rating
* If the user has connected their GitHub account, their timeline should include:
 -  When they create a new repository
 -  When they open a new pull request
 -  When they merge a pull request
 -  When they push commits to a branch

_You can get these activities from the GitHub public events API (which doesn’t require any
authentication)._

* Expose a single endpoint to get the activity feed. This is to avoid duplicate complicated merging logic between multiple API calls, you should.

Final Requirements
-------

You will need to implement the following operations:

* Provide all the data necessary for the UI to display the above wireframes (timeline,
posts, comments, etc)
* Create a new post
* Add a new comment
* Delete a comment
* Rate a user

# Grading
These are the specific things we are looking at:
-----------
* Functionality - Does it work? Does it meet all the needs as outlined in the specification?
* Architecture - Is the API well-designed in terms of best practices and consistency? Is it
straightforward for mobile apps to implement, and can it scale to new features in the
future?
* Documentation - Is there a way to know what endpoints to hit? Are they clear and
accurate?
* Tools - Is the tooling appropriate to the problem? How well does it use the chosen tools?
Does it follow best practices of the framework?
* Style - Is there a clear separation of concerns? Does it reuse code where possible?
* Commits - Is there a clear commit history to follow?

Beyond these specific requirements, there are many other buckets a real API would have to
deal with. You may wish to consider and address some of these things as well. Some examples:

* Performance - can API calls scale to 1M rows?
* Exceptions - How are errors handled?
* Pagination - Does it limit the amount of data returned?
* Security - Are there authentication / authorization mechanisms?
* Tests - Are there tests? Do they pass?
* Validation - Are inputs validated?
