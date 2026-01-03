class Match < ApplicationRecord
  # Associations
  belongs_to :tournament
  belongs_to :created_by, class_name: "User", inverse_of: :created_matches
  belongs_to :winner, class_name: "User", optional: true
  has_many :match_results, dependent: :destroy
  has_many :users, through: :match_results
  has_many :match_achievements, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :match_results
  accepts_nested_attributes_for :match_achievements, allow_destroy: true

  # Validations
  validates :round, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :with_participants, -> { includes(:match_results, :users) }

  # Instance methods
  def participant_ids
    match_results.pluck(:user_id)
  end

  def participant?(user)
    match_results.exists?(user_id: user.id)
  end

  def formatted_duration
    return nil unless duration

    minutes = duration / 60
    seconds = duration % 60
    format("%02d:%02d", minutes, seconds)
  end
end
