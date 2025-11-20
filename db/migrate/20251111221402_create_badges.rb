class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.references :student, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.integer :level, null: false
      t.date :awarded_at, null: false
      t.references :awarded_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    # Student can only have one badge per section per level
    add_index :badges, [:student_id, :section_id, :level], unique: true
    add_index :badges, :awarded_at
  end
end
