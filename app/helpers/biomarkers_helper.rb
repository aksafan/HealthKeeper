# frozen_string_literal: true

module BiomarkersHelper
  def format_biomarker_value(range_value, range_unit)
    "#{format('%<num>0.2f', num: range_value)} #{range_unit}"
  end
end
