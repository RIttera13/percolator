class GetPosts

  # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
  def self.call(page_number = 1, optional_user_id = '')

    offset = (page_number - 1) * 25
    if offset < 0
      offset = 0
    end

    # Get posts for a specific user if a "user_id" is provided, otherwise retun posts from all users.
    if optional_user_id.present?
      @posts = Post.where(user_id: optional_user_id).order('id DESC').limit(25).offset(offset)
    else
      @posts = Post.order('id DESC').limit(25).offset(offset)
    end
    return @posts
  end
end
