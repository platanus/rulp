##
# Object extension to allow numbered LP variables to be initialised dynamically using the following
# syntax.
#
# [Capitalized_varname][lp var type suffix]
#
# Where lp var type suffix is either _lpb for binary, _lpi for integer, or _lpf for float.
# I.e
#
# Rating_lpi is the equivalent of Rating (type integer)
# Is_happy_lpb is the equivalent of Is_happy (type binary/boolean)
##
class << Object
  alias_method :old_const_missing, :const_missing
  def const_missing(value)
    method_name = "#{value}".split("::")[-1] rescue ""
    if ("A".."Z").include?(method_name[0])
      if(method_name.end_with?("lpb"))
        return BV.definition(method_name[0..(method_name[-4] == "_" ? -5 : -4)])
      elsif(method_name.end_with?("lpi"))
        return IV.definition(method_name[0..(method_name[-4] == "_" ? -5 : -4)])
      elsif(method_name.end_with?("lpf"))
        return LV.definition(method_name[0..(method_name[-4] == "_" ? -5 : -4)])
      end
    end
    old_const_missing(value)
  end
end
