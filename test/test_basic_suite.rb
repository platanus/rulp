require_relative 'test_helper'

class BasicSuite < Minitest::Test

  def test_single_binary_var
    each_solver do |solver|
      assert_equal X_lpb.value, nil

      # The minimal value for a single binary variable is 0
      Rulp::Min(X_lpb).(solver)
      assert_equal X_lpb.value, false

      # The maximal value for a single binary variable is 1
      Rulp::Max(X_lpb).(solver)
      assert_equal X_lpb.value, true

      # If we set an upper bound this is respected by the solver
      Rulp::Max(X_lpb)[1 * X_lpb <= 0].(solver)
      assert_equal X_lpb.value, false

      # If we set a lower bound this is respected by the solver
      Rulp::Min(X_lpb)[1 * X_lpb >= 1].(solver)
      assert_equal X_lpb.value, true
    end
  end

  def test_single_integer_var
    each_solver do |solver|
      assert_equal X_lpi.value, nil

      given[ -35 <= X_lpi <= 35 ]

      # Integer variables respect integer bounds
      Rulp::Min(X_lpi).(solver)
      assert_equal X_lpi.value, -35

      # Integer variables respect integer bounds
      Rulp::Max(X_lpi).(solver)
      assert_equal X_lpi.value, 35
    end
  end

  def test_single_general_var
    each_solver do |solver|
      assert_equal X_lpf.value, nil

      given[ -345.4321 <= X_lpf <= 345.4321 ]

      # Integer variables respect integer bounds
      Rulp::Min(X_lpf).(solver)
      assert_in_delta X_lpf.value, -345.4321, 0.001

      # Integer variables respect integer bounds
      Rulp::Max(X_lpf).(solver)
      assert_in_delta X_lpf.value, 345.4321, 0.001
    end
  end
end
