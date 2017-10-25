require_relative 'ast'

class Add < AST
  
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def derivate(priority_table)
    return @expression1.derivate(priority_table) + '+' + @expression2.derivate(priority_table)
  end
  
  def literal(priority_table)
    return @expression1.literal(priority_table) + '+' + @expression2.literal(priority_table)
  end
  
  def simplify(priority_table)
    exp1 = @expression1.simplify(priority_table)
    exp2 = @expression2.simplify(priority_table)
    if exp1.class == Number
      return exp2 if exp1.number == 0
    end
    if exp2.class == Number
      return exp1 if exp2.number == 0
    end
    Add.new(exp1, exp2)
  end
end