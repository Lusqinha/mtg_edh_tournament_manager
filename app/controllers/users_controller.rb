class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[show]

  def show
    user = User.find_by!(uuid: params[:uuid])

    render inertia: "Users/Show", props: {
      profile_user: user.profile_data,
      tournament_stats: user.tournament_stats,
      recent_matches: user.recent_matches_data
    }
  end
end
