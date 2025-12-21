class Tournament < ApplicationRecord
  belongs_to :created_by, class_name: "User", foreign_key: "owner_id"

  has_many :matches, dependent: :destroy
  has_many :tournament_participants, dependent: :destroy
  has_many :users, through: :tournament_participants
  has_many :match_results, dependent: :destroy

  has_many :tournament_organizers, dependent: :destroy
  has_many :organizers, through: :tournament_organizers, source: :user

  validates :name, presence: true
end
