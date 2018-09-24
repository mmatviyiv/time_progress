require 'date'

class Quarter

  QUARTERS = {
      1..3 => 'Q1',
      4..6 => 'Q2',
      7..9 => 'Q3',
      10..12 => 'Q4'
  }

  def name
    current.last
  end

  def progress
    period = current.first
    days = days(period.begin, period.end)
    position = days.index(Date.today)

    position * 100 / days.size
  end

  private

  def days(from, to)
    year = Date.today.year
    dates = Date.new(year, from, 1)..Date.new(year, to, -1)
    dates.to_a
  end

  def current
    QUARTERS.detect{|k, v| k.include?(Date.today.month)}
  end

end