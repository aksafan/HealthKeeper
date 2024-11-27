# frozen_string_literal: true

class CreateReferenceRanges < ActiveRecord::Migration[7.1]
  def change
    create_table :reference_ranges do |t|
      t.references :biomarker, null: false, foreign_key: true
      t.decimal :min_value
      t.decimal :max_value
      t.string :unit
      t.string :source

      t.timestamps
    end
  end
end
