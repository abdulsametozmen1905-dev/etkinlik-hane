class CreateRatings < ActiveRecord::Migration[8.1]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end

    add_index :ratings, [:user_id, :event_id], unique: true
  end
end
