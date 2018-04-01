require 'test_helper'

class ZipToCbsaControllerTest < ActionDispatch::IntegrationTest
  test "should get import" do
    get zip_to_cbsa_import_url
    assert_response :success
  end

end
