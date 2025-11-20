class CreateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :sections do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.text :description
      t.string :icon
      t.integer :position, default: 0

      t.timestamps
    end
    
    add_index :sections, :category
    add_index :sections, :position
  end
end 