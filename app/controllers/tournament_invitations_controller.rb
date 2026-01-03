class TournamentInvitationsController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]

  def show
    @tournament = Tournament.find_by!(invite_code: params[:code])

    if authenticated?
      join_tournament
    else
      session[:invite_code] = params[:code]
      redirect_to new_registration_path, notice: "Crie uma conta ou faça login para entrar no torneio #{@tournament.name}."
    end
  end

  private

  def join_tournament
    if @tournament.users.exists?(id: Current.user.id)
      redirect_to @tournament, notice: "Você já está participando deste torneio."
    else
      @tournament.tournament_participants.create!(user: Current.user)
      redirect_to @tournament, notice: "Você entrou no torneio #{@tournament.name} com sucesso!"
    end
  end
end
