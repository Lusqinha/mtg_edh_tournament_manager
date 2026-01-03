class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]

  def show
    @user = User.find(params[:id])
    
    # Get tournaments where user is a participant
    @participations = @user.tournament_participants
                           .includes(:tournament)
                           .order(score: :desc)

    # Calculate rank for each tournament
    @tournament_stats = @participations.map do |participation|
      tournament = participation.tournament
      rank = tournament.tournament_participants.where("score > ?", participation.score).count + 1
      
      {
        id: tournament.id,
        slug: tournament.slug,
        name: tournament.name,
        score: participation.score,
        rank: rank,
        total_participants: tournament.tournament_participants.count,
        created_at: tournament.created_at
      }
    end

    # Recent matches
    @recent_matches = @user.matches
                           .includes(:winner, :tournament, :created_by)
                           .order(created_at: :desc)
                           .limit(10)
                           .map do |match|
                             {
                               id: match.id,
                               tournament_name: match.tournament.name,
                               winner_nickname: match.winner&.nickname,
                               created_at: match.created_at,
                               is_winner: match.winner_id == @user.id
                             }
                           end

    render inertia: "Users/Show", props: {
      profile_user: @user.as_json(only: [:id, :nickname, :created_at]),
      tournament_stats: @tournament_stats,
      recent_matches: @recent_matches
    }
  end
end
