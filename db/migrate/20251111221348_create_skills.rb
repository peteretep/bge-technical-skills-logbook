class CreateSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :skills do |t|
      t.text :description, null: false
      t.integer :level, null: false, default: 0
      t.references :section, null: false, foreign_key: true
      t.integer :position, default: 0

      t.timestamps
    end
    
    add_index :skills, [:section_id, :level]
    add_index :skills, :position
  end
end
