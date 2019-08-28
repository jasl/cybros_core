# frozen_string_literal: true

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should sign in user-sign-in form" do
    post user_session_path,
      params: { user: { email: "eric@cloud-mes.com",
                        password: "123456" } }
    assert_response :redirect
  end
end
