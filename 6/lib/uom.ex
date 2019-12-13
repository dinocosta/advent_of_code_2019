defmodule UniversalOrbitMap do
  @moduledoc """
  Provides solutions for Advent Of Code Day 6.
  """

  @doc """
  Solves day 6 part one.
  """
  @spec part_one(String.t()) :: Integer.t()
  def part_one(input_file) do
    orbits =
      input_file
      |> File.read!()
      |> String.split()
      |> Enum.map(&String.trim/1)
      |> number_of_orbits()
  end

  @doc """
  Determines the number of direct and indirect orbits given the orbits map.

  ## Example

      iex> UniversalOrbitMap.number_of_orbits(["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L"])
      42
  """
  def number_of_orbits(orbit_map) do
    orbits =
      orbit_map
      |> Enum.map(fn orbit -> String.split(orbit, ")") end)
      |> Enum.map(&List.to_tuple/1)
      |> Enum.reduce(%{}, fn {orbited, orbiter}, map -> Map.update(map, orbiter, [orbited], fn orbitting -> [orbited | orbitting] end) end)

    orbits
    |> Map.keys()
    |> Enum.map(fn body -> number_of_orbits(body, orbits) end)
    |> Enum.sum()
  end

  @spec number_of_orbits(String.t(), Map.t()) :: Integer.t()
  def number_of_orbits(body, orbits) do
    direct_orbits = Map.get(orbits, body, [])

    direct_orbits
    |> Enum.map(fn body -> number_of_orbits(body, orbits) end)
    |> Enum.sum()
    |> Kernel.+(length(direct_orbits))
  end
end
