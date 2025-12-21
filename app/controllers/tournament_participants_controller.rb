class TournamentParticipantsController < ApplicationController
  before_action :set_tournament

  def create
    @participant = @tournament.tournament_participants.build(user_id: params[:user_id])
    
    if @participant.save
      redirect_to @tournament, notice: "Jogador adicionado com sucesso."
    else
      redirect_to @tournament, alert: "Não foi possível adicionar o jogador."
    end
  end

  def destroy
    @participant = @tournament.tournament_participants.find(params[:id])
    @participant.destroy
    redirect_to @tournament, notice: "Jogador removido."
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
