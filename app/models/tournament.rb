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
    is_owner = owner_id == user.id

    as_json(only: %i[id name slug created_at number_of_rounds max_players]).merge(
      created_by: { nickname: created_by.nickname },
      is_organizer: is_organizer,
      is_owner: is_owner,
      invite_code: is_organizer ? invite_code : nil,
      is_participant: participant?(user),
      scorings: tournament_scorings.order(:position).as_json(only: %i[position points]),
      achievements: tournament_achievements.as_json(only: %i[title description points unique_completion]),
      organizers: organizers_data
    )
  end

  def organizers_data
    tournament_organizers.includes(:user).map do |to|
      {
        id: to.id,
        user_id: to.user_id,
        nickname: to.user.nickname,
        avatar_url: to.user.avatar_url,
        is_owner: to.user_id == owner_id
      }
    end
  end

  def standings_data
    participants_with_stats.map do |participant, stats|
      {
        user_id: participant.user_id,
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
        winner: match.winner ? { nickname: match.winner.nickname, avatar_url: match.winner.avatar_url } : nil,
        created_by: { nickname: match.created_by.nickname, avatar_url: match.created_by.avatar_url }
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

  def statistics_data
    {
      overview: overview_stats,
      top_winners: top_winners_stats,
      participation_ranking: participation_ranking_stats,
      achievements_ranking: achievements_ranking_stats
    }
  end

  private

  def overview_stats
    {
      total_matches: matches.count,
      total_participants: tournament_participants.count,
      total_points_distributed: match_results.sum(:score),
      average_match_duration: matches.where.not(duration: nil).average(:duration)&.round || 0
    }
  end

  def top_winners_stats
    matches.where.not(winner_id: nil)
           .group(:winner_id)
           .count
           .sort_by { |_, v| -v }
           .first(5)
           .map do |user_id, wins|
      user = User.find(user_id)
      { nickname: user.nickname, avatar_url: user.avatar_url, wins: wins }
    end
  end

  def participation_ranking_stats
    match_results.group(:user_id)
                 .count
                 .sort_by { |_, v| -v }
                 .first(5)
                 .map do |user_id, matches_played|
      user = User.find(user_id)
      { nickname: user.nickname, avatar_url: user.avatar_url, matches_played: matches_played }
    end
  end

  def achievements_ranking_stats
    MatchAchievement.joins(:match)
                    .where(matches: { tournament_id: id })
                    .group(:user_id)
                    .count
                    .sort_by { |_, v| -v }
                    .first(5)
                    .map do |user_id, count|
      user = User.find(user_id)
      { nickname: user.nickname, avatar_url: user.avatar_url, achievements_count: count }
    end
  end

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
