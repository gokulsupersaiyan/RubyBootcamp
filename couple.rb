class Couple
    attr_accessor :one, :two
    def initialize(one, two)
      @one = one
      @two = two
    end

    def is_equal?(one,two)
      @one == one && @two == two
    end

    def to_s
      "(#{@one},#{@two}})"
    end
end