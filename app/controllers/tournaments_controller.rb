class TournamentsController < ApplicationController
  def index
    tournaments = Tournament.includes(:created_by, :users, :matches).order(created_at: :desc).map do |t|
      t.as_json(only: [ :id, :name, :created_at ]).merge(
        created_by: { nickname: t.created_by.nickname },
        participants_count: t.users.size,
        matches_count: t.matches.size
      )
    end
    render inertia: "Tournaments/Index", props: { tournaments: tournaments }
  end

  def show
    @tournament = Tournament.find(params[:id])

    tournament_data = @tournament.as_json(only: [ :id, :name, :created_at ]).merge(
      created_by: { nickname: @tournament.created_by.nickname },
      is_organizer: @tournament.organizers.exists?(id: Current.user.id)
    )

    participants_data = @tournament.tournament_participants.includes(:user).order(score: :desc).map do |p|
      p.as_json(only: [ :score ]).merge(
        user: { nickname: p.user.nickname }
      )
    end

    matches_data = @tournament.matches.includes(:winner, :created_by).order(created_at: :desc).map do |m|
      m.as_json(only: [ :id, :created_at ]).merge(
        winner: m.winner ? { nickname: m.winner.nickname } : nil,
        created_by: { nickname: m.created_by.nickname }
      )
    end

    available_users = User.where.not(id: @tournament.users.select(:id)).select(:id, :nickname)

    render inertia: "Tournaments/Show", props: {
      tournament: tournament_data,
      participants: participants_data,
      matches: matches_data,
      available_users: available_users
    }
  end

  def new
    render inertia: "Tournaments/New", props: { tournament: Tournament.new }
  end

  def create
    @tournament = Current.user.created_tournaments.build(tournament_params)
    # O criador também é um organizador
    @tournament.organizers << Current.user

    if @tournament.save
      redirect_to @tournament, notice: "Torneio criado com sucesso!"
    else
      render inertia: "Tournaments/New", props: { tournament: @tournament, errors: @tournament.errors }
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :number_of_rounds, :max_players)
  end
end
