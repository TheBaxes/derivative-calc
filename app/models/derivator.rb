class Derivator
  
  
  def initialize(text)
    @tokens = text.scan(/[[:digit:]]+[[:alpha:]]|[[:alpha:]][[:digit:]]+|[[:alpha:]]|[[:digit:]]+|[\+\-\*\/\^\(\)]/)
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
    @tokens.each do |t, i|
      if (t =~ /[[:digit:]]+[[:alpha:]]+/) != nil
        output << Variable.new(t.to_i)
      elsif (t =~ /[[:alpha:]][[:digit:]]+/) != nil
        output << Variable.new(t.tr('x','').to_i)
      elsif (t =~ /[[:digit:]]+/) != nil
        output << (Number.new t.to_i)
      elsif t == "x"
        output << Variable.new(1)
      elsif (t =~ /[\+\-\*\/\^]/) != nil
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
        op << t
      elsif t == '('
        op << t
      elsif t == ')'
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
end