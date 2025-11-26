class CreateJoinTableSkillsExperiencesOutcomes < ActiveRecord::Migration[7.2]
  def change
    create_join_table :skills, :experiences_outcomes do |t|
      t.index [:skill_id, :experiences_outcome_id], name: 'index_skills_eo_on_skill_and_eo'
      t.index [:experiences_outcome_id, :skill_id], name: 'index_skills_eo_on_eo_and_skill'
    end
  end
end
