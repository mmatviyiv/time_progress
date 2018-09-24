class Cron
  attr_accessor :tabs

  def initialize(tabs)
    @tabs = tabs || '* * * * * UTC'
  end

  def time
    return '' if self[0] == '*'
    "#{self[1]}:#{"%02d" % self[0]}"
  end

  def time=(value)
    return if value.empty?
    time = value.split(':')
    self[0], self[1] = time.last, time.first
  end

  def timezone
    self[-1]
  end

  def timezone=(value)
    self[-1] = value
  end

  def weekdays
    return [] if self[-2] == '*'
    self[-2].split(',').map(&:to_i)
  end

  def weekdays=(value)
    self[-2] = value.join(',')
  end

  private

  def [](index)
    @tabs.split(' ')[index]
  end

  def []=(index, value)
    tabs = @tabs.split(' ')
    tabs[index] = value
    @tabs = tabs.join(' ')
  end
end