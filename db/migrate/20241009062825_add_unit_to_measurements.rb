# frozen_string_literal: true

class AddUnitToMeasurements < ActiveRecord::Migration[7.1]
  def change
    add_column :measurements, :unit, :string
  end
end
