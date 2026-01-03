class TournamentParticipantsController < ApplicationController
  before_action :set_tournament
  before_action :authorize_organizer!

  def create
    user = User.find_by(id: params[:user_id])

    return redirect_to @tournament, alert: t("participants.create.not_found") unless user
    return redirect_to @tournament, alert: t("participants.create.already_participant") if @tournament.participant?(user)

    participant = @tournament.tournament_participants.build(user:)

    if participant.save
      redirect_to @tournament, notice: t("participants.create.success")
    else
      redirect_to @tournament, alert: t("participants.create.error")
    end
  end

  def destroy
    participant = @tournament.tournament_participants.find(params[:id])
    participant.destroy

    redirect_to @tournament, notice: t("participants.destroy.success")
  end

  private

  def set_tournament
    @tournament = Tournament.friendly.find(params[:tournament_slug])
  end

  def authorize_organizer!
    return if @tournament.organizer?(Current.user)

    redirect_to tournament_path(@tournament), alert: t("participants.unauthorized")
  end
end
