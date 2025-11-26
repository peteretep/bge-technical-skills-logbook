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

  # Get total skill counts by level across all sections
  def total_skills_by_level
    @total_skills_by_level ||= {
      bronze: Skill.bronze.count,
      silver: Skill.silver.count,
      gold: Skill.gold.count
    }
  end

  # Get demonstrated skill counts by level for this student
  def demonstrated_skills_by_level
    @demonstrated_skills_by_level ||= {
      bronze: student_skills.joins(:skill).where(skills: { level: :bronze }, demonstrated: true).count,
      silver: student_skills.joins(:skill).where(skills: { level: :silver }, demonstrated: true).count,
      gold: student_skills.joins(:skill).where(skills: { level: :gold }, demonstrated: true).count
    }
  end

  # Calculate percentage of demonstrated skills at each level
  def skill_percentages
    total = total_skills_by_level
    demonstrated = demonstrated_skills_by_level

    {
      bronze: total[:bronze].zero? ? 0 : (demonstrated[:bronze].to_f / total[:bronze] * 100).round,
      silver: total[:silver].zero? ? 0 : (demonstrated[:silver].to_f / total[:silver] * 100).round,
      gold: total[:gold].zero? ? 0 : (demonstrated[:gold].to_f / total[:gold] * 100).round
    }
  end

  # Calculate total skills across all levels
  def total_skills_count
    total = total_skills_by_level
    total[:bronze] + total[:silver] + total[:gold]
  end

  # Calculate total demonstrated skills across all levels
  def total_demonstrated_count
    demonstrated = demonstrated_skills_by_level
    demonstrated[:bronze] + demonstrated[:silver] + demonstrated[:gold]
  end

  # Calculate overall percentage
  def total_percentage
    total = total_skills_count
    return 0 if total.zero?
    (total_demonstrated_count.to_f / total * 100).round
  end

  # Determine working level based on demonstrated skills
  # Logic:
  # - 2X: < 30% bronze
  # - 2B: 30-60% bronze
  # - 2R: 60%+ bronze (haven't started silver)
  # - 3X: 60%+ bronze + < 30% silver
  # - 3B: 60%+ bronze + 30-60% silver
  # - 3R: 60%+ bronze + 60%+ silver (haven't started gold)
  # - 4X: 60%+ bronze + 60%+ silver + < 30% gold
  # - 4B: 60%+ bronze + 60%+ silver + 30-60% gold
  # - 4R: 60%+ bronze + 60%+ silver + 60%+ gold
  def working_level
    percentages = skill_percentages
    demonstrated = demonstrated_skills_by_level

    bronze_pct = percentages[:bronze]
    silver_pct = percentages[:silver]
    gold_pct = percentages[:gold]

    if bronze_pct >= 60 && silver_pct >= 60
      # Achieved bronze and silver prerequisites - Level 3 or 4
      if demonstrated[:gold].zero?
        "3R"  # At top of level 3, haven't started gold yet
      elsif gold_pct >= 60
        "4R"
      elsif gold_pct >= 30
        "4B"
      else # 0 < gold_pct < 30
        "4X"
      end
    elsif bronze_pct >= 60
      # Achieved bronze prerequisite - Level 2 or 3
      if demonstrated[:silver].zero?
        "2R"  # At top of level 2, haven't started silver yet
      elsif silver_pct >= 30
        "3B"
      else # 0 < silver_pct < 30
        "3X"
      end
    else
      # Working on bronze - Level 2
      if bronze_pct >= 30
        "2B"
      else
        "2X"
      end
    end
  end
end




