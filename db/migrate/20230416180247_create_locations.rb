class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :category
      t.string :locationData
      t.string :address
      
      t.timestamps
    end
  end
end
