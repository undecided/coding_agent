class Loopy < Array
  alias :current :first

  alias :object :first

  alias :add :push

  def rotate
    push(shift) if any?
    self # Return self for chaining, e.g., loopy.rotate.current
  end
end
