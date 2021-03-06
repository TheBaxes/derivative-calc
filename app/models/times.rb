require_relative 'ast'

class Times < AST
  attr_reader :expression1, :expression2
  
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end
  
  def derivate(priority_table)
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
    
    if @expression1.checkNumberWithVariable 
      return result2 + result1 if @expression2.class == Number
      return result1 + result2
    end
    if @expression2.checkNumberWithVariable
      return result1 + result2 if @expression1.class == Number
      return result2 + result1
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
    if exp1.checkNumberWithVariable
      return Times.new(Number.new(exp2.number*exp1.getNumberOfVariable),\
      Pow.new(Variable.new, Number.new(exp1.getExponent)).simplify(priority_table))\
      if exp2.class == Number
      
      if exp2.class == Add || exp2.class == Sub
        return Add.new(Times.new(exp1, exp2.expression1), Times.new(exp1, exp2.expression2)).simplify(priority_table)
      end
    end
    if exp2.checkNumberWithVariable
      return Times.new(Number.new(exp1.number*exp2.getNumberOfVariable),\
      Pow.new(Variable.new, Number.new(exp2.getExponent)).simplify(priority_table))\
      if exp1.class == Number
        
      if exp1.class == Add || exp1.class == Sub
        return Add.new(Times.new(exp1.expression1, exp2), Times.new(exp1.expression2, exp2)).simplify(priority_table)
      end
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