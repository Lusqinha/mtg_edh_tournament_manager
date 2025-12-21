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
end
