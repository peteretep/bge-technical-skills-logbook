class CreateExperiencesOutcomes < ActiveRecord::Migration[7.2]
  def change
    create_table :experiences_outcomes do |t|
      t.string :code
      t.text :description

      t.timestamps
    end
    add_index :experiences_outcomes, :code, unique: true
  end
end
