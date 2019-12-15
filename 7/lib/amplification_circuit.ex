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

    phase_settings()
    |> Enum.map(fn phase_setting -> compute_output(phase_setting, memory) end)
    |> Enum.sort(&(&1 > &2))
    |> List.first()
  end

  def compute_output(phase_settings, memory, input \\ 0)
  def compute_output([], _, input), do: input
  def compute_output([phase_setting | phase_settings], memory, input) do
    updated_memory =
      memory
      |> Map.put(:input, input)
      |> Map.put(:phase_setting, phase_setting)
      |> TEST.execute()

    compute_output(phase_settings, memory, updated_memory.output)
  end

  @doc """
  Returns a list with all possible phase settings combinations.
  """
  @spec phase_settings() :: [List.t()]
  def phase_settings(), do: Range.new(0, 4) |> Enum.to_list() |> Permutations.of()
end
