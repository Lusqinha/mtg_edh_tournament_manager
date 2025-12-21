class Match < ApplicationRecord
  belongs_to :tournament
  belongs_to :created_by, class_name: "User"
  belongs_to :winner, class_name: "User", optional: true
  has_many :match_results, dependent: :destroy
  has_many :users, through: :match_results

  accepts_nested_attributes_for :match_results

  validates :round, presence: true
end
