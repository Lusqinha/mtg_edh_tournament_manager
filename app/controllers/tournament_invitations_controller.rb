class TournamentInvitationsController < ApplicationController
  allow_unauthenticated_access only: %i[show]

  def show
    @tournament = Tournament.find_by!(invite_code: params[:code])

    if authenticated?
      join_tournament
    else
      save_invite_and_redirect
    end
  end

  private

  def join_tournament
    if @tournament.participant?(Current.user)
      redirect_to @tournament, notice: t("invitations.already_participant")
    else
      @tournament.tournament_participants.create!(user: Current.user)
      redirect_to @tournament, notice: t("invitations.joined", tournament: @tournament.name)
    end
  end

  def save_invite_and_redirect
    session[:invite_code] = params[:code]
    redirect_to new_registration_path, notice: t("invitations.login_required", tournament: @tournament.name)
  end
end
