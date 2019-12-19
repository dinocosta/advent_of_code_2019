defmodule TEST do
  @moduledoc """
  TEST: Thermal Environment Supervision Terminal
  """

  @doc """
  Given the memory contents and the current pointer executes the operation and updates the memory.
  """
  @spec execute(Memory.t()) :: Memory.t()
  def execute(memory) do
    opcode = Memory.at(memory, memory.pointer)
    instruction = Instruction.parse(opcode)

    case instruction.operation do
      :halt -> memory
      _ -> Instruction.run(instruction, memory) |> execute()
    end
  end

  @doc """
  Given the memory contents and the current pointer executes the operation and updates the memory, stopping
  whenever the output instruction is called.
  """
  @spec execute_and_stop(Memory.t()) :: Memory.t()
  def execute_and_stop(memory) do
    opcode = Memory.at(memory, memory.pointer)
    instruction = Instruction.parse(opcode)

    case instruction.operation do
      :halt -> memory
      :output -> Instruction.run(instruction, memory)
      _ -> Instruction.run(instruction, memory) |> execute_and_stop()
    end
  end
end
