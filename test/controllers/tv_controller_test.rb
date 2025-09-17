require "test_helper"

class TvControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get tv_show_url
    assert_response :success
  end
end
