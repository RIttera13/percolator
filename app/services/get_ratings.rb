class GetRatings

  # Use recursive calls to get more objsects, 25 is the maximum number of objects to return
  def self.call(page_number = 0, optional_user_id = '')
    if optional_user_id.present?
      @ratings = Rating.where(user_id: optional_user_id).order('id DESC').limit(25).offset(page_number * 25)
    else
      @ratings = Rating.order('id DESC').limit(25).offset(page_number * 25)
    end
    return @ratings
  end
end
