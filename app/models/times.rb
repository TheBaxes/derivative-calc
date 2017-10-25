require_relative 'ast'

class Times < AST
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def derivate(priority_table)
    #return @expression1.literal(priority_table) + @expression2.derivate(priority_table) \
    #if @expression1.class == Number
    
    #return @expression2.literal(priority_table) + @expression1.derivate(priority_table) \
    #if @expression2.class == Number
    exp1 = @expression1.derivate(priority_table)
    exp1l = @expression1.literal(priority_table)
    exp2 = @expression2.derivate(priority_table)
    exp2l = @expression2.literal(priority_table)
      result = '(' + exp1l + ')*(' + exp2 + ')'
      result += '+(' + exp2l + ')*(' + exp1 + ')'
    
    result
  end
  
  def literal(priority_table)
    return @expression1.literal(priority_table) + '*(' + @expression2.literal(priority_table) + ')' \
    if priority_table[:"#{@expression2.class}"] < priority_table[:Times]
    
    return @expression1.literal(priority_table) + '*' + @expression2.literal(priority_table)
  end
  
  def latex(priority_table)
    if @expression1.checkNumberWithVariable && @expression2.class == Number
      return @expression2.latex(priority_table) + @expression1.latex(priority_table)
    end
    if @expression1.class == Number && @expression2.checkNumberWithVariable
      return @expression1.latex(priority_table) + @expression2.latex(priority_table)
    end
    if priority_table[:"#{@expression1.class}"] < priority_table[:Times]
      result1 = '(' + @expression1.latex(priority_table) + ')'
    else
      result1 = @expression1.latex(priority_table)
    end
    if priority_table[:"#{@expression2.class}"] < priority_table[:Times]
      result2 = '(' + @expression2.latex(priority_table) + ')'
    else
      result2 = @expression2.latex(priority_table)
    end
    
    return result1 + '*' + result2
  end
  
  def simplify(priority_table)
    exp1 = @expression1.simplify(priority_table)
    exp2 = @expression2.simplify(priority_table)
    if exp1.class == Number
      return exp1 if exp1.number == 0
      return exp2 if exp1.number == 1
    end
    if exp2.class == Number
      return exp2 if exp2.number == 0
      return exp1 if exp2.number == 1
    end
    if exp1.checkNumberWithVariable && exp2.checkNumberWithVariable
      c = exp1.getNumberOfVariable * exp2.getNumberOfVariable
      e = exp1.getExponent + exp2.getExponent
      return Times.new(Number.new(c), Pow.new(Variable.new, Number.new(e))).simplify(priority_table)
    end
    if exp1.checkNumberWithVariable && exp2.class == Number
      return Times.new(Number.new(exp2.number*exp1.getNumberOfVariable),\
      Pow.new(Variable.new, Number.new(exp1.getExponent)).simplify(priority_table))
    end
    if exp1.class == Number && exp2.checkNumberWithVariable
      return Times.new(Number.new(exp1.number*exp2.getNumberOfVariable),\
      Pow.new(Variable.new, Number.new(exp2.getExponent)).simplify(priority_table))
    end
    if exp1.class == Number && exp2.class == Number
      return Number.new(exp1.number*exp2.number)
    end
    
    Times.new(exp1, exp2)
  end
  
  def checkNumberWithVariable()
    @expression1.class == Number && @expression2.checkVariable || @expression1.checkVariable && @expression2.class == Number
  end
  
  def getNumberOfVariable()
    return nil unless self.checkNumberWithVariable
    return @expression1.number if @expression1.class == Number
    @expression2.number
  end
  
  def getExponent()
    return nil unless self.checkNumberWithVariable
    return @expression1.getExponent if @expression1.checkVariable
    @expression2.getExponent
  end
end