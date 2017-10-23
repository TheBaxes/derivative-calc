require_relative 'ast'

class Pow < AST
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def derivate(priority_table)
    @expression2.literal(priority_table) + '(' + @expression1.literal(priority_table) \
    + ')^{(' + @expression2.literal(priority_table) + '-1)}(' + @expression1.derivate(priority_table) + ')'
  end
  
  def literal(priority_table)
    '(' + @expression1.literal(priority_table) + ')^' + @expression2.literal(priority_table)
  end
end