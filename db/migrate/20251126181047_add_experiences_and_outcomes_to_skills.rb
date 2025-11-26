class AddExperiencesAndOutcomesToSkills < ActiveRecord::Migration[7.2]
  def change
    add_column :skills, :experiences_and_outcomes, :text
  end
end
