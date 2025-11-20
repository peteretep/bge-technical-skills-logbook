class Badge < ApplicationRecord
  belongs_to :student
  belongs_to :section
  belongs_to :awarded_by, class_name: 'User'

  enum level: { bronze: 0, silver: 1, gold: 2 }

  validates :student_id, uniqueness: { 
    scope: [:section_id, :level],
    message: "already has this badge"
  }
  validates :awarded_at, presence: true
  validates :level, presence: true

  before_validation :set_awarded_at, on: :create

  scope :recent, -> { order(awarded_at: :desc) }
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

  private

  def set_awarded_at
    self.awarded_at ||= Date.today
  end
end




