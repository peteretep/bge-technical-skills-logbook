class AddExperiencesAndOutcomesToSections < ActiveRecord::Migration[7.2]
  def change
    add_column :sections, :experiences_and_outcomes, :text
  end
end
