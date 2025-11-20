class Skill < ApplicationRecord
  belongs_to :section
  has_many :student_skills, dependent: :destroy
  has_many :students, through: :student_skills

  enum level: { bronze: 0, silver: 1, gold: 2 }

  validates :description, presence: true
  validates :level, presence: true

  scope :ordered, -> { order(:position) }
  scope :for_level, ->(lvl) { where(level: lvl) }

  def level_name
    level.capitalize
  end

  def level_icon
    case level
    when 'bronze' then '🥉'
    when 'silver' then '🥈'
    when 'gold' then '🥇'
    end
  end
end




