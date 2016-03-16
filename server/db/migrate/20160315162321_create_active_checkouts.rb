class CreateActiveCheckouts < ActiveRecord::Migration
  def change
    create_table :active_checkouts do |t|
      t.references :book, index: true, foreign_key: true
      t.references :checkout, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
