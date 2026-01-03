class TournamentsController < ApplicationController
  def index
    tournaments = Tournament.includes(:created_by, :users, :matches).order(created_at: :desc).map do |t|
      t.as_json(only: [ :id, :name, :slug, :created_at ]).merge(
        created_by: { nickname: t.created_by.nickname },
        participants_count: t.users.size,
        matches_count: t.matches.size
      )
    end
    render inertia: "Tournaments/Index", props: { tournaments: tournaments }
  end

  def show
    @tournament = Tournament.friendly.find(params[:slug])
    
    available_users = if @tournament.organizers.exists?(id: Current.user.id)
      User.where.not(id: @tournament.users.select(:id)).select(:id, :nickname)
    else
      []
    end

    render inertia: "Tournaments/Show", props: {
      tournament: @tournament.details_for_display(Current.user),
      participants: @tournament.standings_data,
      matches: @tournament.matches_data,
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
    @tournament = Tournament.friendly.find(params[:slug])
    authorize_organizer!(@tournament)

    render inertia: "Tournaments/Edit", props: {
      tournament: @tournament.as_json(include: {
        tournament_scorings: { only: [:id, :position, :points] },
        tournament_achievements: { only: [:id, :title, :description, :points, :unique_completion] }
      })
    }
  end

  def update
    @tournament = Tournament.friendly.find(params[:slug])
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
