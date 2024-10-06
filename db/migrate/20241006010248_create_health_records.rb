class CreateHealthRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :health_records do |t|
      t.references :user, null: false, foreign_key: true
      t.text :notes

      t.timestamps
    end
  end
end
