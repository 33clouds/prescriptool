class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :send_welcome_email

  has_many :prescriptions_as_professional, class_name: "Prescription", foreign_key: :professional_id
  has_many :prescriptions_as_patient, class_name: "Prescription", foreign_key: :patient_id
  has_many :users_specialties
  has_many :specialties, through: :users_specialties

  scope :patients, -> { where(pro: false) }

  def full_name
    return "#{self.first_name} #{self.last_name}"
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end
end
