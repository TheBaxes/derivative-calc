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
    #return @expression1.literal(priority_table) + @expression2.literal(priority_table) \
    #if @expression1.class == Number
    
    #return @expression2.literal(priority_table) + @expression1.literal(priority_table) \
    #if @expression2.class == Number
    
    return @expression1.literal(priority_table) + '*(' + @expression2.literal(priority_table) + ')' \
    if priority_table[:"#{@expression2.class}"] < priority_table[:Sub]
    
    return @expression1.literal(priority_table) + '*' + @expression2.literal(priority_table)
  end
  
  def simplify(priority_table)
    exp1 = @expression1.simplify(priority_table)
    exp2 = @expression2.simplify(priority_table)
    if exp1.class == Number && exp2.class == Number
      return Number.new(exp1.number*exp2.number)
    end
    if exp1.class == Number
      return exp1 if exp1.number == 0
      return exp2 if exp1.number == 1
    end
    if exp2.class == Number
      return exp2 if exp2.number == 0
      return exp1 if exp2.number == 1
    end
    Times.new(exp1, exp2)
  end
end