defmodule SecureContainer do
  @moduledoc """
  Documentation for SecureContainer.
  """

  @doc """
  Solves the first part of the challenge.
  """
  @spec part_one(Integer.t(), Integer.t()) :: Integer.t()
  def part_one(start, stop) do
    Range.new(start, stop)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.filter(&valid?/1)
    |> Enum.count()
  end

  @doc """
  Solves the second part of the challenge.
  """
  @spec part_two(Integer.t(), Integer.t()) :: Integer.t()
  def part_two(start, stop) do
    Range.new(start, stop)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.filter(&extra_valid?/1)
    |> Enum.count()
  end

  @doc """
  Checks if given password is valid or not taking into account that, for a password to be valid, it needs to follow
  these rules:

  - It is a six-digit number.
  - Two adjacent digits are the same (like 22 in 122345).
  - Going from left to right, the digits never decrease;
    they only ever increase or stay the same (like 111123 or 135679).
  """
  @spec valid?(String.t()) :: bool
  def valid?(password) do
    case String.length(password) == 6 do
      false -> false
      true ->
        password
        |> String.codepoints()
        |> _valid?
    end
  end

  defp _valid?(characters, processed \\ [], repeated \\ false)
  defp _valid?([], _, repeated), do: repeated
  defp _valid?([current | characters], [], repeated), do: _valid?(characters, [current], repeated)

  defp _valid?([current | characters], [previous | processed], repeated) do
    cond do
      current == previous -> _valid?(characters, [current | [previous | processed]], true)
      current > previous -> _valid?(characters, [current | [previous | processed]], repeated)
      true -> false
    end
  end

  @doc """
  Checks if given password is valid or not taking into account that, for a password to be valid, it needs to follow
  these rules:

  - It is a six-digit number.
  - Two adjacent digits are the same (like 22 in 122345).
  - Going from left to right, the digits never decrease;
    they only ever increase or stay the same (like 111123 or 135679).
  - The two adjacent matching digits are not part of a larger group of matching digits.

  Here's some examples:

  - 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
  - 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
  - 111122 meets the criteria (even though 1 is repeated more than twice, thus not counting to the "two adjacent
    digits are the same" rule it still contains a double 22, thus the double 22 fulfills that rule).
  """
  @spec extra_valid?(String.t()) :: bool
  def extra_valid?(password) do
    case String.length(password) == 6 do
      false -> false
      true ->
        password
        |> String.codepoints()
        |> _extra_valid?
    end
  end

  def _extra_valid?(characters, processed \\ [], repeated \\ false)
  def _extra_valid?([], _, repeated), do: repeated

  def _extra_valid?([current | characters], [], repeated) do
    {repetitions, rest} = Enum.split_while([current | characters], fn character -> character == current end)

    case length(repetitions) == 2 do
      true -> _extra_valid?(rest, repetitions, true)
      false -> _extra_valid?(rest, repetitions, false)
    end
  end

  def _extra_valid?([current | characters], [previous | processed], repeated) do
    {repetitions, rest} = Enum.split_while([current | characters], fn character -> character == current end)
    repeated = repeated || (length(repetitions) == 2)

    cond do
      current > previous -> _extra_valid?(rest, repetitions ++ processed, repeated)
      true -> false
    end
  end
end
