class AddLocationToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :location

    create_table :locations do |t|
      t.string :name
      t.string :description
    end
  end
end
