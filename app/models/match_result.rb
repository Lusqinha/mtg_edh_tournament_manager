class MatchResult < ApplicationRecord
  belongs_to :user
  belongs_to :match
  belongs_to :tournament

  after_save :update_tournament_score
  after_destroy :update_tournament_score

  private

  def update_tournament_score
    participant = TournamentParticipant.find_or_initialize_by(tournament: tournament, user: user)
    participant.score = tournament.match_results.where(user: user).sum(:score)
    participant.save
  end
end
