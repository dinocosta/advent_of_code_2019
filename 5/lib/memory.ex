defmodule Memory do
  @moduledoc """
  Represents the laptop's memory.
  """

  @type t :: %{state: Map.t(), pointer: Integer.t()}

  defstruct state: %{}, pointer: 0

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
  Returns the element at a given position in memory, taking into account the `mode`.
  The `mode` parameter can only be one of two options:
    - 0: Position Mode. The value returned is the value stored at address at the provided `position`.
    - 1: Immediate Mode. The value returned is the value at `position`.
  """
  @spec at(__MODULE__.t(), Integer.t()) :: Integer.t()
  def at(memory, index, mode \\ 1)
  def at(memory, index, 0), do: __MODULE__.at(memory, Map.get(memory.state, index))
  def at(memory, index, 1), do: Map.get(memory.state, index)

  @doc """
  Updates the memory content at a given position with the provided element.
  """
  @spec update(__MODULE__.t(), Integer.t(), Integer.t()) :: Integer.t()
  def update(memory, index, value) do
    %__MODULE__{ memory | state: %{ memory.state | index => value }}
  end

  @doc """
  Adds the given `units` to the pointer.

  ## Example

      iex> Memory.move_pointer(%Memory{state: %{}, pointer: 0}, 4)
      %Memory{state: %{}, pointer: 4}
  """
  @spec move_pointer(__MODULE__.t(), Integer.t()) :: __MODULE__.t()
  def move_pointer(memory, units), do: %__MODULE__{ memory | pointer: memory.pointer + units }
end
