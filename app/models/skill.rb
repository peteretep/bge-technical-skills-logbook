class Skill < ApplicationRecord
  belongs_to :section
  has_many :student_skills, dependent: :destroy
  has_many :students, through: :student_skills

  has_and_belongs_to_many :experiences_outcomes, join_table: :experiences_outcomes_skills

  enum level: { bronze: 0, silver: 1, gold: 2 }

  validates :description, presence: true
  validates :level, presence: true

  before_save :sync_experiences_outcomes

  scope :ordered, -> { order(:position) }
  scope :for_level, ->(lvl) { where(level: lvl) }

  def level_name
    level.capitalize
  end

  def level_icon
    case level
    when "bronze" then "🥉"
    when "silver" then "🥈"
    when "gold" then "🥇"
    end
  end

  private

  def sync_experiences_outcomes
    return if experiences_and_outcomes.nil? # Allow nil, but treat as empty

    codes = ExperiencesOutcome.parse_codes(experiences_and_outcomes)
    self.experiences_outcomes = codes.map do |code|
      ExperiencesOutcome.find_or_create_by(code: code) do |eo|
        # If creating new, set a placeholder description if not found
        # Ideally these should be pre-seeded
        eo.description ||= "Description for #{code}"
      end
    end
  end
end
