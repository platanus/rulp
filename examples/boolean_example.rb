require_relative "../lib/rulp"

Rulp::log_level = Logger::INFO

##
#
# Given 50 items of varying prices
# Get the minimal sum of 10 items that equals at least $15 dollars
#
##

items       = 50.times.map(&Shop_Item_lpb)
items_count = items.sum
items_costs = items.map{|item| item * Random.rand(1.0...5.0)}.sum

Rulp::Min( items_costs ) [
  items_count  >= 10,
  items_costs  >= 15
].solve


cost = items_costs.evaluate
puts items.map(&:inspect)
##
# 'cost' is the result of the objective function.
# You can retrieve allocations by querying the variables.
# E.g
#   Shop_Item_lpb(4).value
##
