# frozen_string_literal: true

class AddBiomarkerUniqueIndex < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_index :biomarkers, :name, unique: true
  end
end
