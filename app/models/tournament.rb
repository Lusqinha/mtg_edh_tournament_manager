class Tournament < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :created_by, class_name: "User", foreign_key: "owner_id", inverse_of: :created_tournaments
  has_many :matches, dependent: :destroy
  has_many :tournament_participants, dependent: :destroy
  has_many :users, through: :tournament_participants
  has_many :match_results, dependent: :destroy
  has_many :tournament_organizers, dependent: :destroy
  has_many :organizers, through: :tournament_organizers, source: :user
  has_many :tournament_scorings, dependent: :destroy
  has_many :tournament_achievements, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :tournament_scorings, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :tournament_achievements, allow_destroy: true, reject_if: :all_blank

  # Token
  has_secure_token :invite_code

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  # Scopes
  scope :with_associations, -> { includes(:created_by, :users, :matches) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def organizer?(user)
    organizers.exists?(id: user.id)
  end

  def participant?(user)
    users.exists?(id: user.id)
  end

  def details_for_display(user)
    is_organizer = organizer?(user)

    as_json(only: %i[id name slug created_at number_of_rounds max_players]).merge(
      created_by: { nickname: created_by.nickname },
      is_organizer: is_organizer,
      invite_code: is_organizer ? invite_code : nil,
      is_participant: participant?(user),
      scorings: tournament_scorings.order(:position).as_json(only: %i[position points]),
      achievements: tournament_achievements.as_json(only: %i[title description points unique_completion])
    )
  end

  def standings_data
    participants_with_stats.map do |participant, stats|
      {
        user: { nickname: participant.user.nickname, avatar_url: participant.user.avatar_url },
        score: participant.score,
        matches_played: stats[:matches_played],
        wins: stats[:wins],
        win_rate: stats[:win_rate]
      }
    end
  end

  def matches_data
    matches.includes(:winner, :created_by).order(created_at: :desc).map do |match|
      match.as_json(only: %i[id created_at]).merge(
        winner: match.winner ? { nickname: match.winner.nickname } : nil,
        created_by: { nickname: match.created_by.nickname }
      )
    end
  end

  def available_users_for_addition
    User.where.not(id: users.select(:id)).select(:id, :nickname)
  end

  def scoring_for_position(position)
    tournament_scorings.find_by(position: position)&.points || 0
  end

  def recalculate_participant_scores!
    tournament_participants.find_each do |participant|
      total_score = match_results.where(user_id: participant.user_id).sum(:score)
      participant.update!(score: total_score)
    end
  end

  private

  def resolve_friendly_id_conflict(candidates)
    "#{candidates.first}-#{SecureRandom.alphanumeric(4).downcase}"
  end

  def participants_with_stats
    user_ids = tournament_participants.pluck(:user_id)
    matches_count = match_results.where(user_id: user_ids).group(:user_id).count
    wins_count = matches.where(winner_id: user_ids).group(:winner_id).count

    tournament_participants.includes(:user).order(score: :desc).map do |participant|
      user_id = participant.user_id
      matches_played = matches_count[user_id] || 0
      wins = wins_count[user_id] || 0
      win_rate = matches_played.positive? ? ((wins.to_f / matches_played) * 100).round(1) : 0

      [ participant, { matches_played: matches_played, wins: wins, win_rate: win_rate } ]
    end
  end
end
