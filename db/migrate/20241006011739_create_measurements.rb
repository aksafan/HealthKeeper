# frozen_string_literal: true

class CreateMeasurements < ActiveRecord::Migration[7.1]
  def change
    create_table :measurements do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :measurement_type
      t.decimal :value
      t.string :source
      t.string :recordable_type
      t.integer :recordable_id
      t.text :notes

      t.timestamps
    end
  end
end
