class Tournament < ApplicationRecord
  belongs_to :created_by, class_name: "User", foreign_key: "owner_id"

  has_many :matches, dependent: :destroy
  has_many :tournament_participants, dependent: :destroy
  has_many :users, through: :tournament_participants
  has_many :match_results, dependent: :destroy

  has_many :tournament_organizers, dependent: :destroy
  has_many :organizers, through: :tournament_organizers, source: :user

  has_many :tournament_scorings, dependent: :destroy
  has_many :tournament_achievements, dependent: :destroy

  accepts_nested_attributes_for :tournament_scorings, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :tournament_achievements, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true

  def details_for_display(user)
    as_json(only: [ :id, :name, :created_at, :number_of_rounds, :max_players ]).merge(
      created_by: { nickname: created_by.nickname },
      is_organizer: organizers.exists?(id: user.id),
      is_participant: users.exists?(id: user.id),
      scorings: tournament_scorings.order(:position).as_json(only: [:position, :points]),
      achievements: tournament_achievements.as_json(only: [:title, :description, :points, :unique_completion])
    )
  end

  def standings_data
    tournament_participants.includes(:user).order(score: :desc).map do |p|
      matches_played = MatchResult.where(tournament_id: id, user_id: p.user_id).count
      wins = Match.where(tournament_id: id, winner_id: p.user_id).count
      
      p.as_json(only: [ :score ]).merge(
        user: { nickname: p.user.nickname },
        matches_played: matches_played,
        wins: wins,
        win_rate: matches_played > 0 ? ((wins.to_f / matches_played) * 100).round(1) : 0
      )
    end
  end

  def matches_data
    matches.includes(:winner, :created_by).order(created_at: :desc).map do |m|
      m.as_json(only: [ :id, :created_at ]).merge(
        winner: m.winner ? { nickname: m.winner.nickname } : nil,
        created_by: { nickname: m.created_by.nickname }
      )
    end
  end
end
