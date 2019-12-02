defmodule Memory do
  @moduledoc """
  Represents the laptop's memory.
  """

  @type t :: %{state: Map.t()}

  defstruct state: %{}

  @doc """
  Initializes the memory contents given a list of the contents of the memory as strings.
  """
  @spec initialize(List.t()) :: __MODULE__.t()
  def initialize(contents) do
    contents =
      contents
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
    state = for {item, index} <- contents, do: {index, item}, into: %{}

    %__MODULE__{
      state: state
    }
  end

  @doc """
  Returns the element at a given position in memory.
  """
  @spec at(__MODULE__.t(), Integer.t()) :: Integer.t()
  def at(memory, index), do: Map.get(memory.state, index)

  @doc """
  Updates the memory content at a given position with the provided element.
  """
  @spec update(__MODULE__.t(), Integer.t(), Integer.t()) :: Integer.t()
  def update(memory, index, value) do
    %__MODULE__{ memory | state: %{ memory.state | index => value }}
  end
end
