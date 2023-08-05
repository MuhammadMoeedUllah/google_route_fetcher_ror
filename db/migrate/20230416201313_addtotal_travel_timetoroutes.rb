class AddtotalTravelTimetoroutes < ActiveRecord::Migration[7.0]
  def change
    add_column :routes, :totalTravelTime, :string
    add_column :routes, :travelMode, :string
    add_column :routes, :totalTravelDistance, :string
  end
end
