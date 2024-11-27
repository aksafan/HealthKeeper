# frozen_string_literal: true

module DateFormatterHelper
  def format_date_with_time(date)
    date.strftime('%I:%M:%S %P, %A, %B %d, %Y')
  end

  def format_date(date)
    date.strftime('%B %d, %Y')
  end
end
