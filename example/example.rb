require 'find'
# ----------------------------
# DISCLAIMER AND INTRODUCTION
# ----------------------------
#
# This example of the Interpreter pattern
# shows us how to create a language to better
# deal with file management.
#
# Unlike other examples in this series,
# this example of the Interpreter pattern has
# been plucked from Russ Olsen's excellent
# book 'Design Patterns in Ruby'. For more
# information on that wonderful book, visit
# the following link:
# https://www.amazon.com/Design-Patterns-Ruby-Russ-Olsen/dp/0321490452


# ----------------------------
# The Expressions
# ----------------------------
#
# The 'Expression' class is the base class
# for the expressions used in this example.
#
# Expressions are combined within the Interpreter
# pattern to build flexible grammatical statements.
#
# Expressions can be either 'terminal' or 'non-terminal'.
#
# Non-terminal expressions, such as 'And', 'Or', 'Not',
# take in other inputs and are used to build out more
# complex expressions. The non-terminal expressions
# are coorelated with the composite nodes of the Abstract
# Syntax Tree (AST).
#
# As described by Russ Olsen: "Non-terminals have a reference
# to one or more sub-expressions, which allows us to build
# arbitrarily complex trees."
#
# Terminal expressions represent the basic building
# blocks of the language. The terminal expressions are
# coorelated to the leaf nodes of the Abstract Syntax
# Tree (AST).
class Expression
end

# 'All' is a termial expression. It
# returns all of the files in a given
# directory.
class All < Expression
  def evaluate(dir)
    results= []
    Find.find(dir) do |p|
      next unless File.file?(p)
      results << p
    end
    results
  end
end

# 'FileName' is a terminal expression. It
# returns all of the files whose names
# match a given pattern.
class FileName < Expression
  def initialize(pattern)
    @pattern = pattern
  end

  def evaluate(dir)
    results = []
    Dir.entries(dir).each do |e|
      next unless File.file?("#{dir}/#{e}")
      base_name = File.basename(e)
      results << "#{dir}/#{e}" if File.fnmatch(@pattern, base_name)
    end
    results
  end
end

# 'Bigger' is a terminal expression. It searches
# for all of the files with are bigger than some
# specific size.
class Bigger < Expression
  def initialize(size)
    @size = size
  end

  def evaluate(dir)
    results = []
    Dir.entries(dir).each do |e|
      next unless File.file?("#{dir}/#{e}")
      results << e if File.size(e) > @size
    end
    results
  end
end

# 'Writable' is a terminal expression. It returns
# all of the files within a given directory which
# are writable.
class Writable < Expression
  def evaluate(dir)
    results = []
    Dir.entries(dir).each do |e|
      next unless File.file?("#{dir}/#{e}")
      results << e if File.writable?(e)
    end
    results
  end
end

# 'Not' is a non-terminal expression. It allows us
# to combine other expressions in interesting ways.
# For example: We are able to search specifically
# for files that are 'not writable' by subtracting
# the results of a set of 'writable' files from a
# set of 'all' files. Take a look at the 'evaluate'
# method of the 'Not' class for clarification on
# this point.
class Not < Expression
  def initialize(expression)
    @expression = expression
  end

  def evaluate(dir)
    All.new.evaluate(dir) - @expression.evaluate(dir)
  end
end

# 'Or' is a non-terminal expression. It allows us
# to combine two expressions with an 'or' operator.
# It will combine both of the sets of files resulting
# from the two expressions, combine, and sort the two
# sets.
class Or < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    results1 = @expression1.evaluate(dir)
    results2 = @expression2.evaluate(dir)
    (results1 + results2).sort.uniq
  end
end

# 'And' is a non-terminal expression. It allows
# us to combine two sets of files only where
# they intersect. In other words, only files
# common to both sets will be returned.
#
# Given ['a', 'b'] and ['c', 'a', 'd'],
# ['a'] will returned.
class And < Expression
  def initialize(expression1, expression2)
    @expression1 = expression1
    @expression2 = expression2
  end

  def evaluate(dir)
    results1 = @expression1.evaluate(dir)
    results2 = @expression2.evaluate(dir)
    (results1 & results2).sort.uniq
  end
end

# -------------------------------
# The Parser: Creator of the AST
# -------------------------------
#
# The 'Parser' class is resposible for taking in
# a string containing an expression written in
# the language that we've designed for file
# handling. It transforms the string into tokens
# which are then traversed, one at a time, to
# determine which 'Expression' sub class should
# be associated with a given token.
#
# At the end of the parsing process, the 'Parser'
# will return the Abstract Syntax Tree (AST) for
# this example of the Interpreter pattern.
class Parser
  def initialize(text)
    @tokens = text.scan(/\(|\)|[\w\.\*]+/)
  end

  def next_token
    @tokens.shift
  end

  def expression
    token = next_token
    if token.nil?
      nil
    elsif token == '('
      result = expression
      raise 'Expected )' unless next_token == ')'
      result
    elsif token == 'all'
      All.new
    elsif token == 'writable'
      Writable.new
    elsif token == 'bigger'
      Bigger.new(next_token.to_i)
    elsif token == 'filename'
      FileName.new(next_token)
    elsif token == 'not'
      Not.new(expression)
    elsif token == 'and'
      And.new(expression, expression)
    elsif token == 'or'
      Or.new(expression, expression)
    else
      raise "Unexpected token: #{token}"
    end
  end
end

# ---------------------------------
# Evaluating an example expression
# ---------------------------------
#
# In this example expression, we ask for all of the
# writable mp3 files which are bigger than 1024.
parser = Parser.new "and(not (bigger 1024)) (filename *.mp3)"
#parser = Parser.new "not bigger 1024"
# Now, we execute the parser by calling the 'expression' method.
# The Abstract Syntax Tree (AST) is returned to us.
ast = parser.expression

# We set the current 'context' that we want to use
# for this particular AST to the current directory.
#
# The 'context' for an interpreter is passed in after
# the AST has been generated. It is supplied when
# the AST is interpreted.
context = "." # this current directory.

# Now, we can evaluate the AST within the context of
# the current directory.
#
# A set of files matching the criteria dictated in the
# expression, and evaluated within the context of the
# current directory, will be returned.
#
# The AST will recursively evaluate itself in order to
# come to the proper result.
result = ast.evaluate(context)
puts result