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
      @result = Derivator.new(params[:exp]).parse.derivate(priority_table)
    end
  end
end
