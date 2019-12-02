defmodule RocketEquation do
  @moduledoc """
  Documentation for RocketEquation.
  """

  @doc """
  Hello world.

  ## Examples

      iex> RocketEquation.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Solves the first part of the problem given the input file path.
  """
  @spec part_one(String.t()) :: Integer.t()
  def part_one(input_file) do
    {:ok, input} = File.read(input_file)

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&RocketEquation.calculate_fuel/1)
    |> Enum.sum()
  end

  @doc """
  Calculates the fuel requirements for the first part of the problem.
  """
  @spec calculate_fuel(Integer.t()) :: Integer.t()
  def calculate_fuel(mass), do: Kernel.div(mass, 3) - 2

  @doc """
  Solves the second part of the problem given the input file path.
  """
  @spec part_two(String.t()) :: Integer.t()
  def part_two(input_file) do
    {:ok, input} = File.read(input_file)

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&RocketEquation.calculate_full_fuel/1)
    |> Enum.sum()
  end

  @doc """
  Calculates the fuel requirements for the second part of the problem.
  """
  @spec calculate_full_fuel(Integer.t()) :: Integer.t()
  def calculate_full_fuel(mass) do
    fuel = calculate_fuel(mass)

    cond do
      fuel <= 0 -> 0
      true -> fuel + calculate_full_fuel(fuel)
    end
  end
end
