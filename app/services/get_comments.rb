class GetComments

  # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
  def self.call(page_number = 1, optional_user_id = "", optional_post_id = "")
    # verify page number is integer
    page_number = page_number.present? ? page_number.to_i : 1

    offset = (page_number - 1) * 25
    if offset <= 0
      offset = 0
      page_number = 1
    end

    # Optimized by including user to first call
    # Get comments for a specific user if a "user_id" is provided, otherwise retun comments from all users.
    if optional_user_id.present? && optional_post_id.present?
      return { error: "Please send user_id OR post_id, not both." }
    elsif optional_user_id.present?
      @comments = Comment.includes(:user).where(user_id: optional_user_id).order('id DESC').limit(25).offset(offset)
    elsif optional_post_id.present?
      @comments = Comment.includes(:user).where(post_id: optional_post_id).order('id DESC').limit(25).offset(offset)
    else
      @comments = Comment.includes(:user).order('id DESC').limit(25).offset(offset)
    end
    return {comments: @comments, page_number: page_number}
  end
end
