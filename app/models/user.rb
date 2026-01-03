class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :created_tournaments, class_name: "Tournament", foreign_key: "owner_id", dependent: :destroy
  has_many :created_matches, class_name: "Match", foreign_key: "created_by_id", dependent: :destroy

  has_many :tournament_participants, dependent: :destroy
  has_many :tournaments, through: :tournament_participants

  has_many :tournament_organizers, dependent: :destroy
  has_many :organized_tournaments, through: :tournament_organizers, source: :tournament

  has_many :match_results, dependent: :destroy
  has_many :matches, through: :match_results

  normalizes :email_address, with: ->(e) { e&.strip&.downcase }
  normalizes :nickname, with: ->(n) { n.strip }

  validates :nickname, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 12 }
  validates :email_address, uniqueness: true, allow_blank: true
  validates :uuid, presence: true, uniqueness: true, on: :update

  before_create :generate_uuid

  def profile_data
    as_json(only: %i[uuid nickname avatar_url created_at])
  end

  def tournament_stats
    tournament_participants.includes(tournament: :tournament_participants).order(score: :desc).map do |participation|
      tournament = participation.tournament
      higher_scores_count = tournament.tournament_participants.count { |p| p.score > participation.score }

      {
        id: tournament.id,
        slug: tournament.slug,
        name: tournament.name,
        score: participation.score,
        rank: higher_scores_count + 1,
        total_participants: tournament.tournament_participants.size,
        created_at: tournament.created_at
      }
    end
  end

  def recent_matches_data(limit: 10)
    matches.includes(:winner, :tournament).order(created_at: :desc).limit(limit).map do |match|
      {
        id: match.id,
        tournament_name: match.tournament.name,
        winner_nickname: match.winner&.nickname,
        created_at: match.created_at,
        is_winner: match.winner_id == id
      }
    end
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
