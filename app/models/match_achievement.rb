class MatchAchievement < ApplicationRecord
  belongs_to :match
  belongs_to :tournament_achievement
  belongs_to :user
end
