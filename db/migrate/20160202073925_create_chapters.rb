class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.references :movie, index: true, foreign_key: true, null: false
      t.integer :offset, null: false
      t.text :description
      t.date :date

      t.timestamps null: false
    end
  end
end
