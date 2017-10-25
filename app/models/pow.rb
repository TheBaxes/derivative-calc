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
  
  def simplify(priority_table)
    exp1 = @expression1.simplify(priority_table)
    exp2 = @expression2.simplify(priority_table)
    if exp1.class == Number
      return exp1 if exp1.number == 1
    end
    Pow.new(exp1, exp2)
  end
end