require_relative 'test_helper'
# maximize
#   z = 10 * x + 6 * y + 4 * z
#
# subject to
#   p:      x +     y +     z <= 100
#   q: 10 * x + 4 * y + 5 * z <= 600
#   r:  2 * x + 2 * y + 6 * z <= 300
#
# where all variables are non-negative integers
#   x >= 0, y >= 0, z >= 0
#

class SaveToFile < Minitest::Test
  def setup
    LV::clear
    given[ X_lpi >= 0,  Y_lpi >= 0,  Z_lpi >= 0 ]
    @objective = 10 * X_lpi + 6 * Y_lpi + 4 * Z_lpi
    @problem   = Rulp::Max( @objective ) [
                    X_lpi +     Y_lpi +     Z_lpi <= 100,
               10 * X_lpi + 4 * Y_lpi + 5 * Z_lpi <= 600,
               2 *  X_lpi + 2 * Y_lpi + 6 * Z_lpi <= 300
    ]
  end

  def test_save
    sample_output_filename = @problem.get_output_filename
    @problem.save(sample_output_filename)
    assert_equal(IO.read(sample_output_filename), "#{@problem}")
    assert_operator "#{@problem}".length, :>=, 100
  end
end
