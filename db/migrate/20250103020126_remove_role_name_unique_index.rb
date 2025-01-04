# frozen_string_literal: true

class RemoveRoleNameUniqueIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :roles, :name
  end
end
