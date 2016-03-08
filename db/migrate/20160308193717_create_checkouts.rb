class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.timestamp :from
      t.timestamp :to
      t.references :user, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
