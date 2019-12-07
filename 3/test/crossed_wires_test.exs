defmodule CrossedWiresTest do
  use ExUnit.Case
  doctest CrossedWires

  test "result is 6" do
    result = CrossedWires.closest_point([
      "R8,U5,L5,D3",
      "U7,R6,D4,L4"
    ])

    assert result == 6
  end

  test "result is 159" do
    result = CrossedWires.closest_point([
      "R75,D30,R83,U83,L12,D49,R71,U7,L72",
      "U62,R66,U55,R34,D71,R55,D58,R83"
    ])

    assert result == 159
  end

  test "result is 135" do
    result = CrossedWires.closest_point([
      "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
      "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    ])

    assert result == 135
  end
end
