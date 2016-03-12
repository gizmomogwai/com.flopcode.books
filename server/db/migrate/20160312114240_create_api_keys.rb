class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :key
      t.string :for_app
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
