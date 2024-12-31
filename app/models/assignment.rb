# frozen_string_literal: true

class Assignment < ApplicationRecord
  belongs_to :assignee, class_name: 'User'
  belongs_to :assigned, class_name: 'User'
end
