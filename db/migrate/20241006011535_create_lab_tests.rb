class CreateLabTests < ActiveRecord::Migration[7.1]
  def change
    create_table :lab_tests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :biomarker, null: false, foreign_key: true
      t.decimal :value
      t.string :unit
      t.references :reference_range, null: false, foreign_key: true
      t.string :recordable_type
      t.integer :recordable_id
      t.text :notes

      t.timestamps
    end
  end
end
