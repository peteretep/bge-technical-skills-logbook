class Student < ApplicationRecord
  belongs_to :classroom
  has_one :user, through: :classroom
  
  has_many :student_skills, dependent: :destroy
  has_many :skills, through: :student_skills
  has_many :badges, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  # Check if student is ready for a badge at a given section/level
  def ready_for_badge?(section, level)
    total_skills = section.skills.where(level: Skill.levels[level]).count
    return false if total_skills.zero?

    demonstrated_count = student_skills
      .joins(:skill)
      .where(skills: { section: section, level: Skill.levels[level] })
      .where(demonstrated: true)
      .count

    percentage = (demonstrated_count.to_f / total_skills * 100).round
    percentage >= 75 # 75% threshold for "most"
  end

  # Get all demonstrated skills for a section at a level
  def demonstrated_skills_for(section, level)
    student_skills
      .includes(:skill)
      .joins(:skill)
      .where(skills: { section: section, level: Skill.levels[level] })
      .where(demonstrated: true)
  end

  # Check if student has a specific badge
  def has_badge?(section, level)
    badges.exists?(section: section, level: Badge.levels[level])
  end
end




