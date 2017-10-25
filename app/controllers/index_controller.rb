class IndexController < ApplicationController
  def index
    if params[:exp] != nil
      priority_table = {
        :Number => 5,
        :Variable => 5,
        :Add => 2,
        :Sub => 2,
        :Times => 3,
        :Div => 3,
        :Pow => 4
      }
      @original = Derivator.new(params[:exp]).parse.simplify(priority_table)
      @result = Derivator.new(@original.literal(priority_table)).parse.derivate(priority_table)
      @original = @original.latex(priority_table)
      @result_simplified = Derivator.new(@result).parse.simplify(priority_table).latex(priority_table)
    end
  end
end
