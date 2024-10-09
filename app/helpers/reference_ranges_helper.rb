module ReferenceRangesHelper
  def format_reference_range(min, max, unit)
    "#{min} - #{max} #{unit}"
  end
end
