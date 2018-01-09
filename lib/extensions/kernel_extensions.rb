##
# Kernel extension to allow numbered LP variables to be initialised dynamically using the following
# syntax.
#
# [Capitalized_varname][lp var type suffix]( integer )
#
# This is similar to the syntax defined in the object extensions but allows for numbered
# suffixes to quickly generate ranges of similar variables.
#
# Where lp var type suffix is either _lpb for binary, _lpi for integer, or _lpf for float.
# I.e
#
# Rating_lpi(5) is the equivalent of Rating_5 (type integer)
# Is_happy_lpb(2) is the equivalent of Is_happy_2 (type binary/boolean)
# ...
##
module Kernel
  alias_method :old_method_missing, :method_missing
  def method_missing(value, *args)
    method_name = "#{value}" rescue ""
    start = method_name[0]
    if (start <= "Z" && start >= "A")
      case method_name[-3..-1]
      when "lpb"
        method_name = method_name[0..(method_name[-4] == "_" ? -5 : -4)]
        return BV.definition(method_name, args)
      when "lpi"
        method_name = method_name[0..(method_name[-4] == "_" ? -5 : -4)]
        return IV.definition(method_name, args)
      when "lpf"
        method_name = method_name[0..(method_name[-4] == "_" ? -5 : -4)]
        return LV.definition(method_name, args)
      end
    end
    old_method_missing(value, *args)
  end

  def _profile
    start        = Time.now
    return_value = yield
    return return_value, Time.now - start
  end
end


module Kernel
  ##
  # Adds assertion capabilities to ruby.
  # The assert function will raise an error if the inner block returns false.
  # The error will contain the file, line number and source line of the failing assertion.
  ##
  class AssertionException < Exception; end

  ##
  # Ensure the SCRIPT_LINES global variable exists so that we can access the source of the failed assertion
  ##
  ::SCRIPT_LINES__ = {} unless defined? ::SCRIPT_LINES__

  ##
  # If assertion returns false we return a new assertion exception with the failing file and line,
  # and attempt to return the failed source if accessible.
  ##
  def assert(truthy=false)
    unless truthy || (block_given? && yield)
      file, line = caller[0].split(":")
      error_message = "Assertion Failed! < #{file}:#{line}:#{ SCRIPT_LINES__[file][line.to_i - 1][0..-2] rescue ''} >"
      raise AssertionException.new(error_message)
    end
  end
end


def given
  @dummy ||= begin
   dummy =  {}
    class << dummy
      def [](*args)
      end
    end
    dummy
  end
end
