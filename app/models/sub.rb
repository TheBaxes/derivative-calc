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
    return @expression1.literal(priority_table) + '-(' + @expression2.literal(priority_table) + ')' \
    if @expression2.class == Add
    
    return @expression1.literal(priority_table) + '-' + @expression2.literal(priority_table)
  end
  
  def latex(priority_table)
    exp1 = @expression1.latex(priority_table)
    exp1 = '' if exp1 == '0'
    
    return exp1 + '-(' + @expression2.latex(priority_table) + ')' \
    if @expression2.class == Add
    
    return exp1 + '-' + @expression2.latex(priority_table)
  end
  
  def simplify(priority_table)
    exp1 = @expression1.simplify(priority_table)
    exp2 = @expression2.simplify(priority_table)
    if exp2.class == Number
      return exp1 if exp2.number == 0
    end
    if exp1.checkNumberWithVariable && exp2.checkNumberWithVariable
      if (exp1.getExponent == exp2.getExponent)
        c = exp1.getNumberOfVariable - exp2.getNumberOfVariable
        return Times.new(Number.new(c), Pow.new(Variable.new, Number.new(exp1.getExponent))).simplify(priority_table)
      end
    end
    if exp1.class == Number && exp1.number != 0 && exp2.class == Number && exp2.number != 0
      n = exp1.number - exp2.number
      return Number.new(n) unless n < 0
      return Sub.new(Number.new(0), Number.new(n*-1))
    end
    
    Sub.new(exp1, exp2)
  end
end