# frozen_string_literal: true

json.extract! health_record, :id, :user_id, :notes, :created_at, :updated_at, :created_at, :updated_at
json.url health_record_url(health_record, format: :json)
