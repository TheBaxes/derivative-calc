class Derivator
  attr_reader :priority_table
  
  def initialize(text)
    @tokens = text.scan(/[[:alpha:]]|[[:digit:]]+|[\+\-\*\/\^\(\)]/)
    @priority_table_symbols = {
    :'+' => 2,
    :'-' => 2,
    :'*' => 3,
    :'/' => 3,
    :'^' => 4,
    :'(' => 1
  }
  
  @priority_table = {
      :Number => 5,
      :Variable => 5,
      :Add => 2,
      :Sub => 2,
      :Times => 3,
      :Div => 3,
      :Pow => 4
    }
  end
  
  def parse()
    output = []
    op = []
    past_token = nil
    @tokens.each do |t|
      if (past_token == '^')
        raise "Parse exception" unless (t =~ /[[:digit:]]+/) != nil
      end
      if (t =~ /[[:digit:]]+/) != nil
        if (past_token =~ /[[:alpha:]|\)]/) != nil
          output, op = checkOpStack(output, op, '*')
          op << '*'
        end
          output << (Number.new t.to_i)
      elsif t == "x"
        if (past_token =~ /[[:digit:]|\)]+/) != nil
          output, op = checkOpStack(output, op, '*')
          op << '*'
        end
          output << Variable.new
      elsif (t =~ /[\+\-\*\/\^]/) != nil
        output, op = checkOpStack(output, op, t)
        op << t
      elsif t == '('
        unless past_token == nil || (past_token =~ /[\+\-\*\/\^\(]/) != nil
          output, op = checkOpStack(output, op, '*')
          op << '*'
        end
        op << t
      elsif t == ')'
        if (past_token == '(')
          output << Number.new(0)
        end
        while !op.empty? && op.last != '('
          exp2 = output.pop
          exp1 = output.pop
          operation = case op.pop
          when '+'
            Add.new exp1, exp2
          when '-'
            Sub.new exp1, exp2
          when '*'
            Times.new exp1, exp2
          when '/'
            Div.new exp1, exp2
          when '^'
            Pow.new exp1, exp2
          end
          output << operation
        end
        op.pop
      end
      past_token = t
    end
    while !op.empty?
      exp2 = output.pop
      exp1 = output.pop
      operation = case op.pop
      when '+'
        Add.new exp1, exp2
      when '-'
        Sub.new exp1, exp2
      when '*'
        Times.new exp1, exp2
      when '/'
        Div.new exp1, exp2
      when '^'
        Pow.new exp1, exp2
      end
      output << operation
    end
    return Function.new output.last
  end
  
  private
    def checkOpStack(output, op, t)
      while !op.empty? && @priority_table_symbols[:"#{op.last}"] >= @priority_table_symbols[:"#{t}"]
        exp2 = output.pop
        exp1 = output.pop
        operation = case op.pop
        when '+'
          Add.new exp1, exp2
        when '-'
          Sub.new exp1, exp2
        when '*'
          Times.new exp1, exp2
        when '/'
          Div.new exp1, exp2
        when '^'
          Pow.new exp1, exp2
        end
        output << operation
      end
      return output, op
    end
end