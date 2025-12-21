class MatchesController < ApplicationController
  before_action :set_tournament
  before_action :set_match, only: %i[ edit update show ]

  def new
    @match = @tournament.matches.build
    @participants = @tournament.users
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
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Calcular duração se a partida estiver sendo finalizada agora
    if @match.duration.nil? && @match.played_at
      @match.duration = (Time.current - @match.played_at).to_i
    end

    if @match.update(match_params)
      redirect_to @tournament, notice: "Partida finalizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
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
    params.require(:match).permit(:winner_id, match_results_attributes: [:id, :score, :eliminations, :commander_damage, :final_life])
  end
end
