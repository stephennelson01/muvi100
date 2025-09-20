class AddTmdbFieldsToBookmarks < ActiveRecord::Migration[7.1]
  def change
    # Add only if missing
    add_column :bookmarks, :tmdb_id, :integer, null: false unless column_exists?(:bookmarks, :tmdb_id)
    add_column :bookmarks, :media_type, :string, null: false unless column_exists?(:bookmarks, :media_type)

    add_column :bookmarks, :title, :string unless column_exists?(:bookmarks, :title)
    add_column :bookmarks, :poster_path, :string unless column_exists?(:bookmarks, :poster_path)

    # Unique per user + item + type
    unless index_exists?(:bookmarks, [:user_id, :tmdb_id, :media_type], name: "index_bookmarks_on_user_tmdb_and_type")
      add_index :bookmarks, [:user_id, :tmdb_id, :media_type], unique: true, name: "index_bookmarks_on_user_tmdb_and_type"
    end
  end
end
