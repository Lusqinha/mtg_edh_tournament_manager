class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :created_by, class_name: "User"
  belongs_to :winner, class_name: "User", optional: true
  has_many :match_results, dependent: :destroy
  has_many :users, through: :match_results
  has_many :match_achievements, dependent: :destroy

  accepts_nested_attributes_for :match_results
  accepts_nested_attributes_for :match_achievements, allow_destroy: true

  validates :round, presence: true
end
