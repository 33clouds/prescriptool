class Specialty < ApplicationRecord
  has_many :users_specialties
  has_many :users, through: :users_specialties
  validates :name, presence: true
  # include PgSearch::Model
  # multisearchable against: [:name]
end
