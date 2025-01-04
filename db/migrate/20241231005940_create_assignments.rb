# frozen_string_literal: true

class CreateAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :assignments do |t|
      t.references :assignee, null: false, foreign_key: { to_table: :users }
      t.references :assigned, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
