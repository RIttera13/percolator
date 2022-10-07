class GetRatings

  # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
  def self.call(page_number = 0, optional_user_id = "", optional_rater_id = "")
    # verify page number is integer
    page_number = page_number.present? ? page_number.to_i : 1

    offset = (page_number - 1) * 25
    if offset <= 0
      offset = 0
      page_number = 1
    end

    # Get ratings for a specific user if a "user_id" is provided, otherwise retun ratings from all users.
    if optional_user_id.present? && optional_rater_id.present?
      return { error: "Please send user_id OR rater_id, not both." }
    elsif optional_user_id.present?
      @ratings = Rating.where(user_id: optional_user_id).order('id DESC').limit(25).offset(offset)
    elsif optional_rater_id.present?
      @ratings = Rating.where(rater_id: optional_rater_id).order('id DESC').limit(25).offset(offset)
    else
      @ratings = Rating.order('id DESC').limit(25).offset(offset)
    end
    return {ratings: @ratings, page_number: page_number}
  end
end
