defmodule UomTest do
  use ExUnit.Case
  doctest UniversalOrbitMap

  test "solution is 42" do
    orbit_map = ["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"]

    assert UniversalOrbitMap.number_of_orbits(orbit_map) == 42
  end
end
