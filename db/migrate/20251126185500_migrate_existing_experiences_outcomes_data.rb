class MigrateExistingExperiencesOutcomesData < ActiveRecord::Migration[7.2]
  def up
    # Migrate Skills
    Skill.where.not(experiences_and_outcomes: [nil, '']).find_each do |skill|
      codes = skill.experiences_and_outcomes.split(',').map(&:strip).reject(&:blank?)

      codes.each do |code|
        # Find or create the ExperiencesOutcome record with a placeholder description
        eo = ExperiencesOutcome.find_or_create_by!(code: code) do |new_eo|
          new_eo.description = "Placeholder - to be updated in seeds"
        end

        # Associate it with the skill
        skill.experiences_outcomes << eo unless skill.experiences_outcomes.include?(eo)
      end
    end

    # Migrate Sections
    Section.where.not(experiences_and_outcomes: [nil, '']).find_each do |section|
      codes = section.experiences_and_outcomes.split(',').map(&:strip).reject(&:blank?)

      codes.each do |code|
        # Find or create the ExperiencesOutcome record with a placeholder description
        eo = ExperiencesOutcome.find_or_create_by!(code: code) do |new_eo|
          new_eo.description = "Placeholder - to be updated in seeds"
        end

        # Associate it with the section
        section.experiences_outcomes << eo unless section.experiences_outcomes.include?(eo)
      end
    end
  end

  def down
    # Clear all associations
    execute "DELETE FROM experiences_outcomes_skills"
    execute "DELETE FROM experiences_outcomes_sections"
    # Optionally delete all ExperiencesOutcome records
    # ExperiencesOutcome.delete_all
  end
end
