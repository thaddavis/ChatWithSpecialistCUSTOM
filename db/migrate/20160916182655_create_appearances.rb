class CreateAppearances < ActiveRecord::Migration[5.0]
  def change
    create_table :appearances do |t|
      t.integer :user_id
      t.boolean :away
    end

    add_index :appearances, :user_id
  end
end
