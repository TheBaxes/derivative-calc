require_relative 'ast'

class Variable < AST
  def initialize()
  end
  
  def derivate(priority_table)
    return '1'
  end
  
  def literal(priority_table)
    return 'x'
  end
  
  def latex(priority_table)
    return 'x'
  end
  
  def simplify(priority_table)
    return self
  end
  
  def checkNumberWithVariable
    true
  end
  
  def getNumberOfVariable()
    1
  end
  
  def checkVariable
    true
  end
  
  def getExponent
    1
  end
end