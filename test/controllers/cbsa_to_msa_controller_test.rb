require 'test_helper'

class CbsaToMsaControllerTest < ActionDispatch::IntegrationTest
  test "should get import" do
    get cbsa_to_msa_import_url
    assert_response :success
  end

end
