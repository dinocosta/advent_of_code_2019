defmodule CrossedWires do
  @moduledoc """
  Documentation for CrossedWires.
  """

  @type coordinate :: %{x: Integer.t(), y: Integer.t()}

  @doc """
  Solves the first part of the challenge.
  """
  @spec part_one(String.t()) :: Integer.t()
  def part_one(input_file) do
    input_file
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> closest_point()
  end

  @spec closest_point([String.t()]) :: Integer.t()
  def closest_point([first_path | [second_path | []]]) do
    first_coordinates = coordinates(first_path) |> MapSet.new()
    second_coordinates = coordinates(second_path) |> MapSet.new()

    second_coordinates
    |> Enum.filter(fn coordinate -> coordinate in first_coordinates end)
    |> Enum.map(&distance/1)
    |> Enum.filter(fn distance -> distance != 0 end)
    |> Enum.sort()
    |> List.first()
  end

  @doc """
  Calculates the manhattan distance from the provided `coordinate` to the central point (0,0).
  """
  @spec distance(coordinate) :: Integer.t()
  def distance(%{x: x, y: y}), do: Kernel.abs(x) + Kernel.abs(y)

  @doc """
  Calculates the list of coordinates which a wire will cross given its path string.
  """
  @spec coordinates(String.t()) :: {coordinate, [coordinate]}
  def coordinates(path) do
    path
    |> String.split(",")
    |> Enum.reduce({%{x: 0, y: 0}, []}, fn path, {coordinate, coordinates} ->
      {new_coordinate, new_coordinates} = coordinates(coordinate, path)
      {new_coordinate, [new_coordinates | coordinates]}
    end)
    |> elem(1)
    |> List.flatten()
  end

  @doc """
  Determines the list of coordinates given the original coordinate and the movement.
  Will also return the final coordinate.
  """
  @spec coordinates(String.t()) :: {coordinate, [coordinate]}
  def coordinates(coordinate, "L" <> steps),
    do: coordinates(coordinate, String.to_integer(steps), fn %{x: x, y: y}, step -> %{x: x - step, y: y} end)

  def coordinates(coordinate, "R" <> steps),
    do: coordinates(coordinate, String.to_integer(steps), fn %{x: x, y: y}, step -> %{x: x + step, y: y} end)

  def coordinates(coordinate, "D" <> steps),
    do: coordinates(coordinate, String.to_integer(steps), fn %{x: x, y: y}, step -> %{x: x, y: y - step} end)

  def coordinates(coordinate, "U" <> steps),
    do: coordinates(coordinate, String.to_integer(steps), fn %{x: x, y: y}, step -> %{x: x, y: y + step} end)

  def coordinates(coordinate, steps, operation) do
    [head | tail] =
      Range.new(1, steps)
      |> Enum.map(fn step -> operation.(coordinate, step) end)
      |> Enum.reverse()
    {head, [head | tail]}
  end
end
