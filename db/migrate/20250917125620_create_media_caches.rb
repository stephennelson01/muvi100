class CreateMediaCaches < ActiveRecord::Migration[7.1]
  def change
    create_table :media_caches do |t|
      t.string :key, index: true
      t.jsonb :payload
      t.datetime :expires_at

      t.timestamps
    end
  end
end
