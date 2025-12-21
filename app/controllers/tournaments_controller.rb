class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all.order(created_at: :desc)
  end

  def show
    @tournament = Tournament.find(params[:id])
    @participants = @tournament.tournament_participants.includes(:user).order(score: :desc)
    @matches = @tournament.matches.includes(:winner, :created_by).order(created_at: :desc)
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Current.user.created_tournaments.build(tournament_params)
    # O criador também é um organizador
    @tournament.organizers << Current.user

    if @tournament.save
      redirect_to @tournament, notice: "Torneio criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(:name, :number_of_rounds, :max_players)
  end
end
