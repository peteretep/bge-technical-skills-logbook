class Section < ApplicationRecord
  has_many :skills, -> { order(:position) }, dependent: :destroy
  has_many :badges, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  CATEGORIES = [
    'Design and Construct',
    'Materials', 
    'Graphics'
  ].freeze

  validates :category, inclusion: { in: CATEGORIES }

  scope :ordered, -> { order(:position) }
  scope :by_category, ->(cat) { where(category: cat) }

  def bronze_skills
    skills.where(level: :bronze)
  end

  def silver_skills
    skills.where(level: :silver)
  end

  def gold_skills
    skills.where(level: :gold)
  end
end




