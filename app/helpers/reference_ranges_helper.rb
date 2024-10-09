module ReferenceRangesHelper
  def format_range(range_value, range_unit)
    "#{format('%<num>0.2f', num: range_value)} #{range_unit}"
  end
end
