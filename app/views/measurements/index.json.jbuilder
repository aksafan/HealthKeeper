# frozen_string_literal: true

json.array! @measurements, partial: 'measurements/measurement', as: :measurement
