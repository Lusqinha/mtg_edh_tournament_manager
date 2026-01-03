class MatchesController < ApplicationController
  before_action :set_tournament, except: %i[select_tournament]
  before_action :authorize_organizer!, except: %i[select_tournament show]
  before_action :set_match, only: %i[edit update show]

  def select_tournament
    tournaments = Current.user.organized_tournaments.order(created_at: :desc)

    render inertia: "Matches/SelectTournament", props: {
      tournaments: tournaments.as_json(only: %i[id name slug created_at])
    }
  end

  def new
    render inertia: "Matches/New", props: {
      tournament: tournament_json,
      participants: @tournament.users.select(:id, :nickname),
      match_type: params[:type].presence || "live"
    }
  end

  def create
    service = Match::Create.new(@tournament, match_creation_params)

    if service.call
      notice = past_match? ? t("matches.create.success_past") : t("matches.create.success_live")
      redirect_to edit_tournament_match_path(@tournament, service.match), notice:
    else
      render inertia: "Matches/New", props: {
        tournament: tournament_json,
        participants: @tournament.users.select(:id, :nickname),
        match_type: match_creation_params[:match_type],
        errors: service.errors
      }
    end
  end

  def edit
    render inertia: "Matches/Edit", props: {
      tournament: tournament_json,
      match: match_edit_data,
      achievements: @tournament.tournament_achievements.select(:id, :title, :description, :points, :unique_completion),
      scorings: @tournament.tournament_scorings.select(:position, :points)
    }
  end

  def update
    service = Match::Finalize.new(@match, match_finalization_params)

    if service.call
      redirect_to @tournament, notice: t("matches.update.success")
    else
      redirect_to edit_tournament_match_path(@tournament, @match), alert: service.errors.first
    end
  end

  def show
    render inertia: "Matches/Show", props: {
      tournament: tournament_json,
      match: match_edit_data
    }
  end

  private

  def set_tournament
    @tournament = Tournament.friendly.find(params[:tournament_slug])
  end

  def set_match
    @match = @tournament.matches.find(params[:id])
  end

  def authorize_organizer!
    return if @tournament.organizer?(Current.user)

    redirect_to tournament_path(@tournament), alert: t("matches.unauthorized")
  end

  def tournament_json
    @tournament.as_json(only: %i[id name slug])
  end

  def match_creation_params
    params.permit(:match_type, :started_at, :ended_at, player_ids: [])
  end

  def match_finalization_params
    params.permit(
      :duration, :winner_id,
      match_results: %i[id position],
      match_achievements: %i[user_id tournament_achievement_id]
    )
  end

  def past_match?
    params[:match_type] == "past"
  end

  def match_edit_data
    @match.as_json(only: %i[id played_at duration]).merge(
      match_results: match_results_data,
      match_achievements: match_achievements_data
    )
  end

  def match_results_data
    @match.match_results.includes(:user).map do |result|
      result.as_json(only: %i[id score position user_id]).merge(
        user: { id: result.user.id, nickname: result.user.nickname }
      )
    end
  end

  def match_achievements_data
    @match.match_achievements.as_json(only: %i[id user_id tournament_achievement_id])
  end
end
