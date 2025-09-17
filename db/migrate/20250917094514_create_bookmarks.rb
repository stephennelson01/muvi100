class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :media_type
      t.integer :media_id
      t.string :title
      t.string :poster_path
      t.text :overview
      t.string :unique_key

      t.timestamps
    end
    add_index :bookmarks, :unique_key
  end
end
