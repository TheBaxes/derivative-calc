require_relative 'ast'

class Pow < AST
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def derivate(priority_table)
    @expression2.literal(priority_table) + '(' + @expression1.literal(priority_table) \
    + ')^' + (@expression2.number-1).to_s + '(' + @expression1.derivate(priority_table) + ')'
  end
  
  def literal(priority_table)
    return '(' + @expression1.literal(priority_table) + ')^' + @expression2.literal(priority_table)\
    unless @expression1.class == Variable || @expression1.class == Number
    
    @expression1.literal(priority_table) + '^' + @expression2.literal(priority_table)
  end
  
  def latex(priority_table)
    return '(' + @expression1.latex(priority_table) + ')^' + @expression2.latex(priority_table)\
    unless @expression1.class == Variable || @expression1.class == Number
    
    @expression1.latex(priority_table) + '^' + @expression2.latex(priority_table)
  end
  
  def simplify(priority_table)
    exp1 = @expression1.simplify(priority_table)
    exp2 = @expression2.simplify(priority_table)
    if exp1.class == Pow
      return Pow.new(@expression1.getFunction, Number.new(@expression1.getExponent + @expression2.number))
    end
    if exp1.class == Number
      return exp1 if exp1.number == 1
      return Number.new(exp1.number ** exp2.number)
    end
    return exp1 if exp2.number == 1
    Pow.new(exp1, exp2)
  end
  
  def checkNumberWithVariable()
    return @expression1.checkNumberWithVariable
  end
  
  def getNumberOfVariable()
    return nil unless @expression1.checkNumberWithVariable
    return @expression1.getNumberOfVariable
  end
  
  def checkVariable
    @expression1.checkVariable
  end
  
  def getFunction
    @expression1
  end
  
  def getExponent
    @expression2.number
  end
end