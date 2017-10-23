require_relative 'ast'

class Sub < AST
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def derivate(priority_table)
    return @expression1.derivate(priority_table) + '-(' + @expression2.derivate(priority_table) + ')' 
  end
  
  def literal(priority_table)
    return @expression1.literal(priority_table) + '-(' + @expression2.literal(priority_table) + ')' 
  end
end