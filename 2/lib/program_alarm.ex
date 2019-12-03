defmodule ProgramAlarm do

  @doc """
  Solves the first part of the problem given the path of the input file.
  """
  @spec part_one(String.t()) :: String.t()
  def part_one(input_file) do
    memory =
      input_file
      |> File.read!()
      |> String.trim()
      |> String.split(",")
      |> Memory.initialize()

    # Replacing initial memory contents as per instructioned.
    memory =
      memory
      |> Memory.update(1, 12)
      |> Memory.update(2, 2)

    memory
    |> process()
    |> Map.get(:state)
    |> Map.get(0)
  end

  @doc """
  Solves the second part of the problem given the path of the input file.
  """
  @spec part_two(String.t()) :: String.t()
  def part_two(input_file) do
    memory =
      input_file
      |> File.read!()
      |> String.trim()
      |> String.split(",")
      |> Memory.initialize()

    values = for noun <- Range.new(0, 99), verb <- Range.new(0, 99), do: {noun, verb}

    case recursive_part_two(values, memory, 19690720) do
      {noun, verb} -> (100 * noun) + verb
        nil -> IO.puts("Error finding final solution!")
    end
  end

  def recursive_part_two([], _, _), do: nil
  def recursive_part_two([{noun, verb} | values], memory, objetive) do
    result =
      memory
      |> Memory.update(1, noun)
      |> Memory.update(2, verb)
      |> process()
      |> Map.get(:state)
      |> Map.get(0)

    case result == objetive do
      true -> {noun, verb}
      false -> recursive_part_two(values, memory, objetive)
    end
  end

  @doc """
  Processes the memory contents and returns the final memory contents after processing.
  """
  @spec process(Memory.t(), Integer.t()) :: Memory.t()
  def process(memory, pointer \\ 0)
  def process(memory, pointer) do
    case Memory.at(memory, pointer) do
      1 -> process(add(memory, pointer + 1), pointer + 4)
      2 -> process(multiply(memory, pointer + 1), pointer + 4)
      99 -> memory
    end
  end

  def add(memory, pointer), do: execute_operation(memory, pointer, pointer + 1, pointer + 2, &Kernel.+/2)
  def multiply(memory, pointer), do: execute_operation(memory, pointer, pointer + 1, pointer + 2, &Kernel.*/2)

  @doc """
  Given the memory and two indexes performs the addition of the values in that memory positions,
  while saving the result of the operation at the provided `output_position`.
  """
  @spec add(Memory.t(), Integer.t(), Integer.t(), Integer.t()) :: Memory.t()
  def add(memory, first_position, second_position, output_position) do
    result = Memory.at(memory, first_position) + Memory.at(memory, second_position)
    Memory.update(memory, output_position, result)
  end

  @doc """
  Given the memory and two indexes performs the multiplication of the values in that memory positions,
  while saving the result of the operation at the provided `output_position`.
  """
  @spec multiply(Memory.t(), Integer.t(), Integer.t(), Integer.t()) :: Memory.t()
  def multiply(memory, first_position, second_position, output_position) do
    result = Memory.at(memory, first_position) * Memory.at(memory, second_position)
    Memory.update(memory, output_position, result)
  end

  @spec execute_operation(Memory.t(), Integer.t(), Integer.t(), Integer.t(), Function.t()) :: Memory.t()
  def execute_operation(memory, first_position, second_position, output_position, function) do
    first_value = Memory.at(memory, Memory.at(memory, first_position))
    second_value = Memory.at(memory, Memory.at(memory, second_position))
    result = function.(first_value, second_value)

    Memory.update(memory, Memory.at(memory, output_position), result)
  end
end
