class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :classrooms, dependent: :destroy
  has_many :students, through: :classrooms
  has_many :awarded_badges, class_name: 'Badge', foreign_key: 'awarded_by_id'

  validates :name, presence: true
  validates :school, presence: true
end
