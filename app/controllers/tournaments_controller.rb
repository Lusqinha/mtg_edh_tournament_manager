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

    tournament_data = @tournament.as_json(only: [ :id, :name, :created_at, :number_of_rounds, :max_players ]).merge(
      created_by: { nickname: @tournament.created_by.nickname },
      is_organizer: @tournament.organizers.exists?(id: Current.user.id),
      scorings: @tournament.tournament_scorings.order(:position).as_json(only: [:position, :points]),
      achievements: @tournament.tournament_achievements.as_json(only: [:title, :description, :points, :unique_completion])
    )

    participants_data = @tournament.tournament_participants.includes(:user).order(score: :desc).map do |p|
      matches_played = MatchResult.where(tournament_id: @tournament.id, user_id: p.user_id).count
      wins = Match.where(tournament_id: @tournament.id, winner_id: p.user_id).count
      
      p.as_json(only: [ :score ]).merge(
        user: { nickname: p.user.nickname },
        matches_played: matches_played,
        wins: wins,
        win_rate: matches_played > 0 ? ((wins.to_f / matches_played) * 100).round(1) : 0
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
    render inertia: "Tournaments/New", props: { 
      tournament: Tournament.new(
        tournament_scorings: [],
        tournament_achievements: []
      ) 
    }
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

  def edit
    @tournament = Tournament.find(params[:id])
    authorize_organizer!(@tournament)

    render inertia: "Tournaments/Edit", props: {
      tournament: @tournament.as_json(include: {
        tournament_scorings: { only: [:id, :position, :points] },
        tournament_achievements: { only: [:id, :title, :description, :points, :unique_completion] }
      })
    }
  end

  def update
    @tournament = Tournament.find(params[:id])
    authorize_organizer!(@tournament)

    if @tournament.update(tournament_params)
      redirect_to @tournament, notice: "Torneio atualizado com sucesso!"
    else
      render inertia: "Tournaments/Edit", props: { 
        tournament: @tournament.as_json(include: {
          tournament_scorings: { only: [:id, :position, :points] },
          tournament_achievements: { only: [:id, :title, :description, :points, :unique_completion] }
        }), 
        errors: @tournament.errors 
      }
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(
      :name, :number_of_rounds, :max_players,
      tournament_scorings_attributes: [:id, :position, :points, :_destroy],
      tournament_achievements_attributes: [:id, :title, :description, :points, :unique_completion, :_destroy]
    )
  end

  def authorize_organizer!(tournament)
    unless tournament.organizers.exists?(id: Current.user.id)
      redirect_to tournament_path(tournament), alert: "Você não tem permissão para editar este torneio."
    end
  end
end
