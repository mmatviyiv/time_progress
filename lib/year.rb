require 'date'

class Year
  def name
    Date.today.year
  end

  def progress
    Date.today.yday() * 100 / Time.days_in_year
  end
end