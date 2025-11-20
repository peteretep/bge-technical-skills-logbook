class CreateStudents < ActiveRecord::Migration[7.2]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :students, [:classroom_id, :last_name, :first_name]
  end
end