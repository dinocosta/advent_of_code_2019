defmodule TEST do
  @moduledoc """
  TEST: Thermal Environment Supervision Terminal
  """

  @doc """
  Solves part one of day 5.
  """
  def part_one(input_file) do
    input_file
    |> File.read!()
    |> String.strip()
    |> String.split(",")
    |> Memory.initialize()
    |> execute()
  end

  @doc """
  Given the memory contents and the current pointer executes the operation and updates the memory.
  """
  @spec execute(Memory.t()) :: Memory.t()
  def execute(%{pointer: pointer} = memory) do
    opcode = Memory.at(memory, memory.pointer)
    instruction = Instruction.parse(opcode)

    case instruction.operation do
      :halt -> memory
      operation -> Instruction.run(instruction, memory) |> execute()
    end
  end
end
