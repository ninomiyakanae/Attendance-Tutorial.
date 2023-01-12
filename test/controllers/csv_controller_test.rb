require 'test_helper'

class CsvControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get csv_index_url
    assert_response :success
  end

end
