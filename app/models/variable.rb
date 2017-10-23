require_relative 'ast'

class Variable < AST
  def initialize(number)
    @number = number
  end
  
  def derivate(priority_table)
    return @number.to_s
  end
  
  def literal(priority_table)
    return 'x' if @number == 1
    return @number.to_s + 'x'
  end
end