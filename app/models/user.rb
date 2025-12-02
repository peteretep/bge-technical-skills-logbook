class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :classrooms, dependent: :destroy
  has_many :students, through: :classrooms
  has_many :awarded_badges, class_name: 'Badge', foreign_key: 'awarded_by_id'

  validates :name, presence: true
  validates :school, presence: true
  validates :email, presence: true, uniqueness: true

  def password_required?
    super && provider.blank?
  end

  def email_required?
    super && provider.blank?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.school = extract_school_from_email(auth.info.email)
    end
  end

  def self.extract_school_from_email(email)
    domain = email.split('@').last
    domain.split('.').first.capitalize
  end
end
