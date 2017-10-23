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
    if priority_table[:"#{@expression2.class}"] < priority_table[:Times]
      result = exp1l + '*(' + exp2 + ')'
    else
      result = exp1l + '*' + exp2
    end
    
    if priority_table[:"#{@expression1.class}"] < priority_table[:Times]
      result += '+' + exp2l + '*(' + exp1 + ')'
    else
      result += '+' + exp2l + '*' + exp1
    end
    
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