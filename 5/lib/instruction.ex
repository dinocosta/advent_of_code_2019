defmodule Instruction do
  @moduledoc """
  Implements all behaviour related with instruction parsing and execution.
  """

  @type t :: %{operation: atom, modes: [Integer.t()]}

  defstruct operation: nil, modes: [0, 0, 0]

  alias Memory

  @doc """
  Parses the instruction into an instrunction map.

  ## Example

    iex> Instruction.parse(2)
    %{operation: :multiply, modes: [0, 0, 0]}
    iex> Instruction.parse(102)
    %{operation: :multiply, modes: [1, 0, 0]}
    iex> Instruction.parse(1002)
    %{operation: :multiply, modes: [0, 1, 0]}
    iex> Instruction.parse(1101)
    %{operation: :add, modes: [1, 1, 0]}
  """
  @spec parse(Integer.t()) :: Map.t()
  def parse(1), do: %__MODULE__{operation: :add, modes: [0, 0, 0]}
  def parse(2), do: %__MODULE__{operation: :multiply, modes: [0, 0, 0]}
  def parse(3), do: %__MODULE__{operation: :input}
  def parse(4), do: %__MODULE__{operation: :output}
  def parse(5), do: %__MODULE__{operation: :jump_if_true}
  def parse(6), do: %__MODULE__{operation: :jump_if_false}
  def parse(7), do: %__MODULE__{operation: :less_than}
  def parse(8), do: %__MODULE__{operation: :equals}
  def parse(99), do: %{operation: :halt}
  def parse(instruction) when instruction > 100 do
    operation = rem(instruction, 100) |> parse() |> Map.get(:operation)
    modes =
      instruction
      |> div(100)
      |> Integer.to_string()
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.map(&String.to_integer/1)

    # Add the default zero values seeing as, for example, if the instruction is "0102" it gets parsed to an integer
    # as 102, thus we lose the leftmost 0. At the same the default value for the third mode is zero, so this
    # also takes care of that.
    modes = modes ++ List.duplicate(0, 3 - length(modes))

    %{operation: operation, modes: modes}
  end

  @doc """
  Executes the provided `instruction` given the program's `memory` and current `pointer`, which should be pointing
  to the opcode which generated the instruction. It also updates the memory's pointer to the next opcode
  depending on the instruction to be run.
  """
  @spec run(Instruction.t(), Memory.t()) :: Memory.t()
  # OPCODE 3: ADD
  def run(%{operation: :add} = instruction, memory) do
    [first_mode, second_mode, _] = instruction.modes
    first_operand = Memory.at(memory, memory.pointer + 1, first_mode)
    second_operand = Memory.at(memory, memory.pointer + 2, second_mode)
    result = first_operand + second_operand

    Memory.update(memory, Memory.at(memory, memory.pointer + 3), result)
    |> Memory.move_pointer(4)
  end

  # OPCODE 2: MULTIPLY
  def run(%{operation: :multiply} = instruction, memory) do
    [first_mode, second_mode, _] = instruction.modes
    first_operand = Memory.at(memory, memory.pointer + 1, first_mode)
    second_operand = Memory.at(memory, memory.pointer + 2, second_mode)
    result = first_operand * second_operand

    Memory.update(memory, Memory.at(memory, memory.pointer + 3), result)
    |> Memory.move_pointer(4)
  end

  # OPCODE 3: INPUT
  def run(%{operation: :input}, memory) do
    value =
      IO.gets("Input: ")
      |> String.trim()
      |> String.to_integer()

    Memory.update(memory, Memory.at(memory, memory.pointer + 1), value)
    |> Memory.move_pointer(2)
  end

  # OPCODE 4: OUTPUT
  def run(%{operation: :output}, memory) do
    value = Memory.at(memory, Memory.at(memory, memory.pointer + 1))
    IO.puts(value)

    Memory.move_pointer(memory, 2)
  end

  # OPCODE 5: JUMP IF TRUE
  def run(%{operation: :jump_if_true} = instruction, memory) do
    [first_mode, second_mode, _] = instruction.modes
    first_parameter = Memory.at(memory, memory.pointer + 1, first_mode)
    second_parameter = Memory.at(memory, memory.pointer + 2, second_mode)

    case first_parameter != 0 do
      true -> Memory.set_pointer(memory, second_parameter)
      false -> Memory.move_pointer(memory, 3)
    end
  end

  # OPCODE 6: JUMP IF FALSE
  def run(%{operation: :jump_if_false} = instruction, memory) do
    [first_mode, second_mode, _] = instruction.modes
    first_parameter = Memory.at(memory, memory.pointer + 1, first_mode)
    second_parameter = Memory.at(memory, memory.pointer + 2, second_mode)

    case first_parameter == 0 do
      true -> Memory.set_pointer(memory, second_parameter)
      false -> Memory.move_pointer(memory, 3)
    end
  end

  # OPCODE 7: LESS THAN
  def run(%{operation: :less_than} = instruction, memory) do
    [first_mode, second_mode, _] = instruction.modes
    first_parameter = Memory.at(memory, memory.pointer + 1, first_mode)
    second_parameter = Memory.at(memory, memory.pointer + 2, second_mode)
    third_parameter = Memory.at(memory, memory.pointer + 3)

    case first_parameter < second_parameter do
      true -> Memory.update(memory, third_parameter, 1) |> Memory.move_pointer(4)
      false -> Memory.update(memory, third_parameter, 0) |> Memory.move_pointer(4)
    end
  end

  # OPCODE 8: EQUALS
  def run(%{operation: :equals} = instruction, memory) do
    [first_mode, second_mode, _] = instruction.modes
    first_parameter = Memory.at(memory, memory.pointer + 1, first_mode)
    second_parameter = Memory.at(memory, memory.pointer + 2, second_mode)
    third_parameter = Memory.at(memory, memory.pointer + 3)

    case first_parameter == second_parameter do
      true -> Memory.update(memory, third_parameter, 1) |> Memory.move_pointer(4)
      false -> Memory.update(memory, third_parameter, 0) |> Memory.move_pointer(4)
    end
  end

  def run(%{operation: :halt}, memory), do: memory

  @spec execute_operation(Memory.t(), Integer.t(), Integer.t(), Integer.t(), Function.t()) :: Memory.t()
  def execute_operation(memory, first_position, second_position, output_position, function) do
    first_operand = Memory.at(memory, Memory.at(memory, first_position))
    second_operand = Memory.at(memory, Memory.at(memory, second_position))
    result = function.(first_operand, second_operand)

    Memory.update(memory, Memory.at(memory, output_position), result)
  end
end
