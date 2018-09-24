class Visualizer

  def initialize(percentage, length=15, empty='░', filled='▓')
    @length = length
    @empty = empty
    @filled = filled
    @percentage = percentage
  end

  def print
    filled = @percentage * @length / 100
    empty = @length - filled

    @filled * filled + @empty * empty
  end

end