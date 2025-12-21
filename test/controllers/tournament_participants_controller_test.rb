require "test_helper"

class TournamentParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get tournament_participants_create_url
    assert_response :success
  end

  test "should get destroy" do
    get tournament_participants_destroy_url
    assert_response :success
  end
end
