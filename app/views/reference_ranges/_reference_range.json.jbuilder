# frozen_string_literal: true

json.extract! reference_range, :id, :biomarker_id, :min_value, :max_value, :unit, :source, :created_at, :updated_at,
              :created_at, :updated_at
json.url reference_range_url(reference_range, format: :json)
