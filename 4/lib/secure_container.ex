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
  Checks if given password is valid or not taking into account that, for a password to be valid, it needs to follow
  these rules:

  - It is a six-digit number.
  - Two adjacent digits are the same (like 22 in 122345).
  - Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
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
end
