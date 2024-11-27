# frozen_string_literal: true

json.extract! biomarker, :id, :name, :created_at, :updated_at
json.url biomarker_url(biomarker, format: :json)
