class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats, :id => false do |t|
      t.primary_key :id, limit: 8
      t.string :title
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
