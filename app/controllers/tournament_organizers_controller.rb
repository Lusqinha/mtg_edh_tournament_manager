class TournamentOrganizersController < ApplicationController
  before_action :set_tournament
  before_action :authorize_owner!

  def create
    user = User.find_by(id: params[:user_id])

    return redirect_to @tournament, alert: t("organizers.create.not_found") unless user
    return redirect_to @tournament, alert: t("organizers.create.already_organizer") if @tournament.organizer?(user)
    return redirect_to @tournament, alert: t("organizers.create.not_participant") unless @tournament.participant?(user)

    @tournament.organizers << user
    redirect_to @tournament, notice: t("organizers.create.success", nickname: user.nickname)
  end

  def destroy
    organizer = @tournament.tournament_organizers.find(params[:id])

    if organizer.user_id == @tournament.owner_id
      return redirect_to @tournament, alert: t("organizers.destroy.cannot_remove_owner")
    end

    organizer.destroy
    redirect_to @tournament, notice: t("organizers.destroy.success")
  end

  private

  def set_tournament
    @tournament = Tournament.friendly.find(params[:tournament_slug])
  end

  def authorize_owner!
    return if @tournament.owner_id == Current.user.id

    redirect_to @tournament, alert: t("organizers.unauthorized")
  end
end
