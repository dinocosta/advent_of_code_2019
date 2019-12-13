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

  def part_two(input_file) do
    input_file
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.trim/1)
    |> orbital_transfers()
  end

  @doc """
  Calculates the least number of orbital transfers required to go from "YOU" to "SAN" given
  the provided `orbit_map`.

  ## Example

    iex> orbital_transfers(["COM)B", "B)C", "C)D", "D)E", "E)F", "B)G", "G)H", "D)I", "E)J", "J)K", "K)L", "K)YOU", "I)SAN"])
    4
  """
  @spec orbital_transfers(List.t()) :: nil | Integer.t()
  def orbital_transfers(orbit_map) do
    orbit_map
    |> paths()
    |> calculate_distance("YOU")
  end

  # Constructs a map with the list of bodies you can reach given the body you're at.
  defp paths(orbit_map) do
    orbit_map
    |> Enum.map(fn orbit -> String.split(orbit, ")") end)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.reduce(%{}, &update_paths/2)
  end

  defp update_paths({orbited, orbiter}, map) do
    map
    |> Map.update(orbiter, [orbited], fn orbitting -> [orbited | orbitting] end)
    |> Map.update(orbited, [orbiter], fn orbiters -> [orbiter | orbiters] end)
  end

  @doc """
  Calculates the least amount of steps you have to take to reach "SAN" given the `start` point, using the
  `paths` map as reference.
  """
  @spec calculate_distance(Map.t(), String.t()) :: nil | Integer.t()
  def calculate_distance(paths, start) do
    paths
    |> Map.get(start)
    |> Enum.map(fn body -> calculate_distance(paths, body, "", 0) end)
    |> Enum.min()
  end

  @doc """
  Calculates the least amount of steps that are needed to reach "SAN". If there's no way to reach "SAN" than
  `nil` is returned.
  """
  @spec calculate_distance(Map.t(), String.t(), String.t(), Integer.t()) :: Integer.t() | nil
  def calculate_distance(_, "SAN", _, distance), do: distance - 1

  def calculate_distance(paths, current, previous, distance) do
    destinations =
      paths
      |> Map.get(current)
      |> Enum.filter(fn body -> body != previous end)

    case destinations do
      [] -> nil
      destinations ->
        destinations
        |> Enum.map(fn body -> calculate_distance(paths, body, current, distance + 1) end)
        |> Enum.min()
    end
  end
end
