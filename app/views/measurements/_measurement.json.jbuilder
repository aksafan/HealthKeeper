json.extract! measurement, :id, :user_id, :type, :value, :source, :recordable_type, :recordable_id, :notes,
              :created_at, :updated_at, :created_at, :updated_at
json.url measurement_url(measurement, format: :json)
