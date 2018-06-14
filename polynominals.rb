class Polynominal
  def initialize(*coefficients)
    raise ArgumentError, 'Not a valid polynominal' unless coefficients.length >= 2 \
        || ((coefficients[0].is_a? Array) && coefficients[0].length >= 2)

    @coefficients = coefficients.length >= 2 ? coefficients : coefficients[0]
  end


  def get_coefficient_for_degree(degree)
    raise ArgumentError, 'Not a vaild degress' if degree < 0
    @coefficients[@coefficients.length - degree - 1]
  end

  def to_s
    result = ''
    for degree in (@coefficients.length - 1).downto(0)
        coefficient = get_coefficient_for_degree(degree)
        next if coefficient.zero?
        result += coefficient.to_s
        unless degree.zero?
            result += 'X'
            result += "^#{degree}" if degree > 1
            result += ' + '
        end
    end
    result.end_with?('+ ') ? result[0..result.length - 3] : result
  end
end

#two constructor methods
puts Polynominal.new([1, 2, 3])
puts Polynominal.new(1, 2, 3)

#excluding
puts Polynominal.new(1,0,0,0,0,1)
puts Polynominal.new(1,0)

#error handing
puts Polynominal.new(1)