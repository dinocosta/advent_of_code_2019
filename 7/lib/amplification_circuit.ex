defmodule AmplificationCircuit do
  @doc """
  Solves part 1 of day 7!
  """
  @spec part_one(String.t()) :: String.t()
  def part_one(input_file) do
    memory =
      input_file
      |> File.read!()
      |> String.trim()
      |> String.split(",")
      |> Memory.initialize()

    phase_settings(:part_one)
    |> Enum.map(fn phase_setting -> compute_output(phase_setting, memory) end)
    |> Enum.sort(&(&1 > &2))
    |> List.first()
  end

  def compute_output(phase_settings, memory, part \\ :part_one, input \\ 0)
  def compute_output([], _, _, input), do: input
  def compute_output([phase_setting | phase_settings], memory, part, input) do
    updated_memory =
      memory
      |> Map.put(:input, input)
      |> Map.put(:phase_setting, phase_setting)

    updated_memory = case part do
      :part_one -> TEST.execute(updated_memory)
      :part_two -> TEST.execute_and_stop(updated_memory)
    end

    compute_output(phase_settings, memory, part, updated_memory.output)
  end

  @doc """
  Solves part 2 of day 7!
  """
  @spec part_two(String.t()) :: String.t()
  def part_two(input_file) do
    memory =
      input_file
      |> File.read!()
      |> String.trim()
      |> String.split(",")
      |> Memory.initialize()
      |> solve_part_two()
  end

  def solve_part_two(memory) do
    # Here's the algorithm to compute the feedback output:
    # 1. Set the :phase_setting for every amplifier's memory
    # 2. Run the whole amplifier chain using 0 as the input.
    #     Contrary to part one, this time you stop the amplifier execution whenevers
    #     the :output operation is executed.
    # 3. Obtain the output from E
    # 4. If the last instruction run on E was a :halt then return 3.
    #     Otherwise run from 2. but use the value from 3.
    phase_settings(:part_two)
    |> Enum.map(fn phase_setting -> run_feedback(memory, phase_setting) end)
    |> Enum.sort(&(&1 > &2))
    |> List.first()
  end

  def run_amplifiers([], [], input), do: []
  def run_amplifiers([memory | memories], input) do
    updated_memory =
      memory
      |> Map.put(:input, input)
      |> TEST.execute_and_stop()

    [updated_memory | compute_feedback_output(memories, updated_memory.output)]
  end

  def compute_feedback_output_recursive([], _), do: []
  def compute_feedback_output_recursive([memory | memories], input) do
    new_memory =
      memory
      |> Map.put(:input, input)
      |> TEST.execute_and_stop()

    [new_memory | compute_feedback_output_recursive(memories, new_memory.output)]
  end

  def compute_feedback_output(memories, input \\ 0)
  def compute_feedback_output(memories, input) do
    updated_memories = compute_feedback_output_recursive(memories, input)
    amplifier_e = updated_memories |> Enum.reverse() |> List.first()
    last_operation = Memory.at(amplifier_e, amplifier_e.pointer)

    case last_operation do
      99 -> amplifier_e.output
      _ -> compute_feedback_output(updated_memories, amplifier_e.output)
    end

  end

  def run_feedback(memory, phase_setting) do
    amplifiers =
      phase_setting
      |> Enum.map(fn phase_value -> Map.put(memory, :phase_setting, phase_value) end)

    compute_feedback_output(amplifiers)
  end

  @doc """
  Returns a list with all possible phase settings combinations.
  """
  @spec phase_settings(atom) :: [List.t()]
  def phase_settings(:part_one), do: Range.new(0, 4) |> Enum.to_list() |> Permutations.of()
  def phase_settings(:part_two), do: Range.new(5, 9) |> Enum.to_list() |> Permutations.of()
end
