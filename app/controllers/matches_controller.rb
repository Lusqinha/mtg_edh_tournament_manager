class MatchesController < ApplicationController
  before_action :set_tournament, except: [:select_tournament]
  before_action :authorize_organizer!, except: [:select_tournament, :show]
  before_action :set_match, only: %i[ edit update show ]

  def select_tournament
    @tournaments = Current.user.organized_tournaments.order(created_at: :desc)
    render inertia: "Matches/SelectTournament", props: {
      tournaments: @tournaments
    }
  end

  def new
    @match = @tournament.matches.build
    participants = @tournament.users.select(:id, :nickname)
    render inertia: "Matches/New", props: {
      tournament: @tournament,
      participants: participants
    }
  end

  def create
    @match = @tournament.matches.build(
      created_by: Current.user,
      played_at: Time.current,
      round: @tournament.matches.count + 1
    )

    if params[:player_ids].blank?
      redirect_to new_tournament_match_path(@tournament), alert: "Selecione pelo menos um jogador."
      return
    end

    if @match.save
      params[:player_ids].each do |user_id|
        @match.match_results.create(user_id: user_id, tournament: @tournament)
      end
      redirect_to edit_tournament_match_path(@tournament, @match), notice: "Partida iniciada!"
    else
      participants = @tournament.users.select(:id, :nickname)
      render inertia: "Matches/New", props: {
        tournament: @tournament,
        participants: participants,
        errors: @match.errors
      }
    end
  end

  def edit
    match_data = @match.as_json(only: [ :id, :played_at, :duration ]).merge(
      match_results: @match.match_results.includes(:user).map do |result|
        result.as_json(only: [ :id, :score, :position, :user_id ]).merge(
          user: { id: result.user.id, nickname: result.user.nickname }
        )
      end,
      match_achievements: @match.match_achievements.map do |ma|
        {
          id: ma.id,
          user_id: ma.user_id,
          tournament_achievement_id: ma.tournament_achievement_id
        }
      end
    )

    achievements = @tournament.tournament_achievements.select(:id, :title, :description, :points, :unique_completion)
    scorings = @tournament.tournament_scorings.select(:position, :points)

    render inertia: "Matches/Edit", props: {
      tournament: @tournament,
      match: match_data,
      achievements: achievements,
      scorings: scorings
    }
  end

  def update
    ActiveRecord::Base.transaction do
      # Update match details
      @match.update!(
        duration: params[:duration],
        winner_id: params[:winner_id]
      )

      # Update results and calculate scores
      params[:match_results].each do |result_data|
        result = @match.match_results.find(result_data[:id])
        
        # Calculate score based on position
        position_points = @tournament.tournament_scorings.find_by(position: result_data[:position])&.points || 0
        
        # Calculate score based on achievements
        achievement_points = 0
        if params[:match_achievements]
          user_achievements = params[:match_achievements].select { |ma| ma[:user_id] == result.user_id }
          user_achievements.each do |ua|
            achievement = @tournament.tournament_achievements.find(ua[:tournament_achievement_id])
            achievement_points += achievement.points
          end
        end

        total_score = position_points + achievement_points

        result.update!(
          position: result_data[:position],
          score: total_score
        )
      end

      # Update achievements
      @match.match_achievements.destroy_all
      if params[:match_achievements]
        params[:match_achievements].each do |ma|
          @match.match_achievements.create!(
            user_id: ma[:user_id],
            tournament_achievement_id: ma[:tournament_achievement_id]
          )
        end
      end

      # Update tournament participants scores
      @tournament.tournament_participants.each do |participant|
        total_score = @tournament.match_results.where(user_id: participant.user_id).sum(:score)
        participant.update!(score: total_score)
      end
    end

    redirect_to @tournament, notice: "Partida finalizada com sucesso!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_tournament_match_path(@tournament, @match), alert: "Erro ao salvar partida: #{e.message}"
  end

  def show
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def set_match
    @match = @tournament.matches.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:winner_id, match_results_attributes: [ :id, :score, :eliminations, :commander_damage, :final_life ])
  end

  def authorize_organizer!
    unless @tournament.organizers.exists?(id: Current.user.id)
      redirect_to tournament_path(@tournament), alert: "Você não tem permissão para gerenciar partidas deste torneio."
    end
  end
end
