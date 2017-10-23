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
end