require_relative 'ast'

class Div < AST
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def derivate(priority_table)
    exp1 = @expression1.derivate(priority_table)
    exp1l = @expression1.literal(priority_table)
    exp2 = @expression2.derivate(priority_table)
    exp2l = @expression2.literal(priority_table)
    '(((' + exp2l + ')*(' + exp1 + '))-((' + exp1l + ')*(' + exp2 + ')))/(' + exp2l + ')^2'
  end
  
  def literal(priority_table)
    '(' + @expression1.literal(priority_table) + ')/(' + @expression2.literal(priority_table) + ')'
  end
end