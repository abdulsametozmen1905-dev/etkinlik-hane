class AddPublishedToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :published, :boolean, default: false, null: false
  end
end
