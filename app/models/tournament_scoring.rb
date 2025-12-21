class TournamentScoring < ApplicationRecord
  belongs_to :tournament

  validates :position, presence: true, numericality: { greater_than: 0 }
  validates :points, presence: true, numericality: { only_integer: true }
end
