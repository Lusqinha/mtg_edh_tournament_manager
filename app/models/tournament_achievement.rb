class TournamentAchievement < ApplicationRecord
  belongs_to :tournament
  has_many :match_achievements, dependent: :destroy

  validates :title, presence: true
  validates :points, presence: true, numericality: { only_integer: true }
end
