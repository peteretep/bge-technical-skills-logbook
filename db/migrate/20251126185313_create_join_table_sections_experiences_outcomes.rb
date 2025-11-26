class CreateJoinTableSectionsExperiencesOutcomes < ActiveRecord::Migration[7.2]
  def change
    create_join_table :sections, :experiences_outcomes do |t|
      t.index [:section_id, :experiences_outcome_id], name: 'index_sections_eo_on_section_and_eo'
      t.index [:experiences_outcome_id, :section_id], name: 'index_sections_eo_on_eo_and_section'
    end
  end
end
