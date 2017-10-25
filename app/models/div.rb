require_relative 'ast'

class Div < AST
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
    '(((' + exp2l + ')*(' + exp1 + '))-((' + exp1l + ')*(' + exp2 + ')))/(' + exp2l + ')^2'
  end
  
  def literal(priority_table)
    '(' + @expression1.literal(priority_table) + ')/(' + @expression2.literal(priority_table) + ')'
  end
  
  def latex(priority_table)
    '\frac{' + @expression1.latex(priority_table) + '}{' + @expression2.latex(priority_table) + '}'
  end
  
  def simplify(priority_table)
    exp1 = @expression1.simplify(priority_table)
    exp2 = @expression2.simplify(priority_table)
    if exp2.class == Number
      raise "Divide by 0" if exp2.number == 0
      return exp1 if exp2.number == 1
    end
    if exp1.class == Number
      return exp1 if exp1.number == 0
    end
    if exp1.checkNumberWithVariable && exp2.checkNumberWithVariable
      c1 = exp1.getNumberOfVariable
      c2 = exp2.getNumberOfVariable
      e1 = exp1.getExponent
      e2 = exp2.getExponent
      gcd = c1.gcd(c2)
      return Div.new(Number.new(c1 / gcd), Number.new(c2 / gcd)).simplify(priority_table)\
      if e1 == e2
      return Div.new(Times.new(Number.new(c1/gcd), Pow.new(Variable.new, Number.new(e1-e2))).simplify(priority_table),\
      Number.new(c2/gcd)).simplify(priority_table) if e1 > e2
      return Div.new(Number.new(c1 / gcd), Times.new(Number.new(c2 / gcd),\
      Pow.new(Variable.new, Number.new(e2-e1))).simplify(priority_table)).simplify(priority_table)
    end
    if exp1.checkNumberWithVariable && exp2.class == Number
      gcd = exp1.getNumberOfVariable.gcd(exp2.number)
      unless gcd == 1
        div1 = exp1.getNumberOfVariable/gcd
        div2 = exp2.number/gcd
        return Div.new(Pow.new(Variable.new, Number.new(exp1.getExponent)).simplify(priority_table),\
        Number.new(div2)).simplify(priority_table) if div1 == 1
        return Div.new(Times.new(Number.new(div1), Pow.new(Variable.new, Number.new(exp1.getExponent)).simplify(priority_table)),\
        Number.new(div2)).simplify(priority_table)
      end
    end
    if exp1.class == Number && exp2.checkNumberWithVariable
      gcd = exp2.getNumberOfVariable.gcd(exp1.number)
      unless gcd == 1
        div2 = exp2.getNumberOfVariable/gcd
        div1 = exp1.number/gcd
        return Div.new(Number.new(div1), Pow.new(Variable.new, Number.new(exp2.getExponent)).simplify(priority_table))\
        .simplify(priority_table) if div2 == 1
        return Div.new(Number.new(div1),Times.new(Number.new(div2),\
         Pow.new(Variable.new, Number.new(exp2.getExponent)).simplify(priority_table))).simplify(priority_table)
      end
    end
    if exp1.class == Number && exp2.class == Number
      gcd = exp1.number.gcd(exp2.number)
      return Div.new(Number.new(exp1.number / gcd), Number.new(exp2.number / gcd)).simplify(priority_table)\
      unless gcd == 1
    end
    Div.new(exp1, exp2)
  end
  
  def checkVariable
    false
  end
end