class CreateRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :routes do |t|
      t.string :origin
      t.string :destination
      t.string :routeSummary
      t.string :data
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
