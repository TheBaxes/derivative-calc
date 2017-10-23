require_relative 'ast'

class Number < AST
  def initialize(number)
    @number = number
  end
  
  def derivate(priority_table)
    return '0'
  end
  
  def literal(priority_table)
    return @number.to_s
  end
end