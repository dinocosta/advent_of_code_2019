defmodule CrossedWiresTest do
  use ExUnit.Case
  doctest CrossedWires

  test "part one result is 6" do
    result = CrossedWires.closest_point([
      "R8,U5,L5,D3",
      "U7,R6,D4,L4"
    ])

    assert result == 6
  end

  test "part one result is 159" do
    result = CrossedWires.closest_point([
      "R75,D30,R83,U83,L12,D49,R71,U7,L72",
      "U62,R66,U55,R34,D71,R55,D58,R83"
    ])

    assert result == 159
  end

  test "part one result is 135" do
    result = CrossedWires.closest_point([
      "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
      "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    ])

    assert result == 135
  end

  test "part two result is 30" do
    result = CrossedWires.fewest_steps([
      "R8,U5,L5,D3",
      "U7,R6,D4,L4"
    ])

    assert result == 30
  end

  test "part two result is 610" do
    result = CrossedWires.fewest_steps([
      "R75,D30,R83,U83,L12,D49,R71,U7,L72",
      "U62,R66,U55,R34,D71,R55,D58,R83"
    ])

    assert result == 610
  end

  test "part two result is 410" do
    result = CrossedWires.fewest_steps([
      "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51",
      "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    ])

    assert result == 410
  end
end
