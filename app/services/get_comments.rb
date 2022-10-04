class GetComments

  # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
  def self.call(page_number = 0, optional_user_id = '')
    # Get comments for a specific user if a "user_id" is provided, otherwise retun comments from all users.
    if optional_user_id.present?
      @comments = Comment.where(user_id: optional_user_id).order('id DESC').limit(25).offset(page_number * 25)
    else
      @comments = Comment.order('id DESC').limit(25).offset(page_number * 25)
    end
    return @comments
  end
end
