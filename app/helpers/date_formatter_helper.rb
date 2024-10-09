module DateFormatterHelper
  def format_date(date)
    date.strftime("%I:%M:%S %P, %A, %B %d, %Y")
  end
end
