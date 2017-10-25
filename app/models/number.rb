require_relative 'ast'

class Number < AST
  attr_reader :number
  
  def initialize(number)
    @number = number
  end
  
  def derivate(priority_table)
    return '0'
  end
  
  def literal(priority_table)
    return @number.to_s
  end
  
  def latex(priority_table)
    return @number.to_s
  end
  
  def simplify(priority_table)
    return self
  end
end