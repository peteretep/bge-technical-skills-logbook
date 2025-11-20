class CreateClassrooms < ActiveRecord::Migration[7.2]
  def change
    create_table :classrooms do |t|
      t.string :name, null: false
      t.string :year_group
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :classrooms, [:user_id, :name]
  end
end