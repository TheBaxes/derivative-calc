require_relative 'ast'

class Function < AST
  def initialize(expression)
    @expression = expression 
  end
  
  def derivate(priority_table)
    @expression.derivate(priority_table)
  end
  
  def literal(priority_table)
    @expression.literal(priority_table)
  end
  
  def simplify(priority_table)
    @expression.simplify(priority_table)
  end
end