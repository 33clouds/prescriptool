class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :prescriptions_as_professional, class_name: "Prescription", foreign_key: :professional_id
  has_many :prescriptions_as_patient, class_name: "Prescription", foreign_key: :patient_id
  has_many :users_specialties
  has_many :specialties, through: :users_specialties
  has_many :notifications, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  include PgSearch::Model
  multisearchable against: [:first_name, :last_name]

  scope :patients, -> { where(pro: false) }

  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
end
