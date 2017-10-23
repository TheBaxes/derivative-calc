require_relative 'ast'

class Function < AST
  def initialize(expression)
    @expression = expression 
  end
  
  def derivate(priority_table)
    exp = @expression.derivate(priority_table)
    "f'(x) = " + exp
  end
end