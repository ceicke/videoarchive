class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :filename, null: false
      t.text :description
      t.datetime :start
      t.datetime :end

      t.timestamps null: false
    end
  end
end
