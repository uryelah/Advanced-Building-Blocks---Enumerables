# frozen_string_literal: true

module MyGem
  module TopLevel
    def oop?(sym)
      result = false
      case sym
      when :+
        result = true
      when :-
        result = true
      when :*
        result = true
      when :/
        result = true
      end
      result
    end

    def oop_def(sym, memo)
      return memo unless memo.nil?

      result = nil
      case sym
      when :+
        result = 0
      when :-
        result = 0
      when :*
        result = 1
      when :/
        result = 1.0
      end
      result
    end

    def nil_asign(operation, memo)
      return nil if operation.nil?

      oop_def(operation, memo)
    end

    def oop_eval(first, second, operation)
      return nil if first.nil?

      first.method(operation).call(second)
    end
  end
end

class Object
  include MyGem::TopLevel
end
