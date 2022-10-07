require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  test "Valid if Activity new creates a new activity object containing." do

    response = Activity.new("activity", { title: "New Activity", data: {data_title: "Data Title", data_body: "Data body has text.", data_result: 1} }, Time.now)
    assert response.present?
    assert response.is_a?(Activity)
    assert_match "activity", response[:type]
    assert_match "Data Title", response[:data][:data][:data_title]
    assert_match "Data body has text.", response[:data][:data][:data_body]
    assert response[:data][:data][:data_result].to_i == 1
    assert response[:date].is_a?(DateTime) || response[:date].is_a?(Date) || response[:date].is_a?(Time)
  end

end
