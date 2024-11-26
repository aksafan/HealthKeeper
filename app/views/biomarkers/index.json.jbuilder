# frozen_string_literal: true

json.array! @biomarkers, partial: 'biomarkers/biomarker', as: :biomarker
