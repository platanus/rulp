require_relative "../lib/rulp"


Rulp::log_level = Logger::DEBUG

# maximize
#   objective = 10 * x + 6 * y + 4 * z
#
# subject to
#   p:      x +     y +     z <= 100
#   q: 10 * x + 4 * y + 5 * z <= 600
#   r:  2 * x + 2 * y + 6 * z <= 300
#
# where all variables are non-negative integers
#   x >= 0, y >= 0, z >= 0
#


given[

X_lpi >= 0,
Y_lpi >= 0,
Z_lpi >= 0

]

Rulp::Max( objective = 10 * X_lpi + 6 * Y_lpi + 4 * Z_lpi ) [
                            X_lpi +     Y_lpi +     Z_lpi <= 100,
                       10 * X_lpi + 4 * Y_lpi + 5 * Z_lpi <= 600,
                       2 *  X_lpi + 2 * Y_lpi + 6 * Z_lpi <= 300
].cbc

result = objective.evaluate

##
# 'result' is the result of the objective function.
# You can retrieve the values of variables by using the 'value' method
# E.g
#   X_lpi.value == 32
#   Y_lpi.value == 67
#   Z_lpi.value == 0
##
