# frozen_string_literal: true

class AddUniqueIndexToRolesName < ActiveRecord::Migration[7.1]
  def change
    add_index :roles, :name, unique: true
  end
end
