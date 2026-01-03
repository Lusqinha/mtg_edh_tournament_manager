class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[show edit update]
  before_action :authorize_organizer!, only: %i[edit update]

  def index
    tournaments = Tournament.with_associations.recent.map do |tournament|
      tournament.as_json(only: %i[id name slug created_at]).merge(
        created_by: { nickname: tournament.created_by.nickname },
        participants_count: tournament.users.size,
        matches_count: tournament.matches.size
      )
    end

    render inertia: "Tournaments/Index", props: { tournaments: }
  end

  def show
    available_users = @tournament.organizer?(Current.user) ? @tournament.available_users_for_addition : []

    render inertia: "Tournaments/Show", props: {
      tournament: @tournament.details_for_display(Current.user),
      participants: @tournament.standings_data,
      matches: @tournament.matches_data,
      available_users:
    }
  end

  def new
    render inertia: "Tournaments/New", props: {
      tournament: Tournament.new(tournament_scorings: [], tournament_achievements: [])
    }
  end

  def create
    @tournament = Current.user.created_tournaments.build(tournament_params)
    @tournament.organizers << Current.user

    if @tournament.save
      redirect_to @tournament, notice: t("tournaments.create.success")
    else
      render inertia: "Tournaments/New", props: { tournament: @tournament, errors: @tournament.errors }
    end
  end

  def edit
    render inertia: "Tournaments/Edit", props: { tournament: tournament_with_nested_attributes }
  end

  def update
    if @tournament.update(tournament_params)
      redirect_to @tournament, notice: t("tournaments.update.success")
    else
      render inertia: "Tournaments/Edit", props: { tournament: tournament_with_nested_attributes, errors: @tournament.errors }
    end
  end

  private

  def set_tournament
    @tournament = Tournament.friendly.find(params[:slug])
  end

  def tournament_params
    params.require(:tournament).permit(
      :name, :number_of_rounds, :max_players,
      tournament_scorings_attributes: %i[id position points _destroy],
      tournament_achievements_attributes: %i[id title description points unique_completion _destroy]
    )
  end

  def authorize_organizer!
    return if @tournament.organizer?(Current.user)

    redirect_to tournament_path(@tournament), alert: t("tournaments.unauthorized")
  end

  def tournament_with_nested_attributes
    @tournament.as_json(include: {
      tournament_scorings: { only: %i[id position points] },
      tournament_achievements: { only: %i[id title description points unique_completion] }
    })
  end
end
