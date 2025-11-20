class CreateStudentSkills < ActiveRecord::Migration[7.2]
  def change
    create_table :student_skills do |t|
      t.references :student, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.boolean :demonstrated, default: false
      t.date :demonstrated_at
      t.text :teacher_notes

      t.timestamps
    end
    
    add_index :student_skills, [:student_id, :skill_id], unique: true
    add_index :student_skills, :demonstrated
  end
end
