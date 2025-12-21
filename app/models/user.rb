class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  
  has_many :created_tournaments, class_name: "Tournament", foreign_key: "created_by_id", dependent: :destroy
  has_many :created_matches, class_name: "Match", foreign_key: "created_by_id", dependent: :destroy
  
  has_many :tournament_participants, dependent: :destroy
  has_many :tournaments, through: :tournament_participants
  
  has_many :tournament_organizers, dependent: :destroy
  has_many :organized_tournaments, through: :tournament_organizers, source: :tournament
  
  has_many :match_results, dependent: :destroy
  has_many :matches, through: :match_results

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :nickname, with: ->(n) { n.strip.downcase }

  validates :nickname, presence: true, uniqueness: true
end
