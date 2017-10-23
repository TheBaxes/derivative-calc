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
end