defmodule SpaceImageFormat do

  # The dimensions of the image for part one.
  @width 25
  @height 6

  @doc """
  Given the input file for the day solves the first part of the challenge.
  """
  @spec part_one(String.t()) :: Integer.t()
  def part_one(input_file) do
    input_file
    |> File.read!()
    |> String.trim()
    |> layers(@height, @width)
    |> solve_part_one()
  end

  @doc """
  Given the layers of an image, finds the layer that contains the fewest 0 digits and then returns the
  number of 1 digits multiplied by the number of 2 digits for that given layer.

  # Example

    iex> SpaceImageFormat.solve_part_one([[[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [0, 1, 2]]])
    1
    iex> SpaceImageFormat.solve_part_one([[[1, 2, 2], [4, 2, 6]], [[7, 8, 9], [0, 1, 2]]])
    3
  """
  @spec solve_part_one(List.t()) :: Integer.t()
  def solve_part_one(layers) do
    [{_, layer} | _] =
      layers
      |> Enum.map(fn layer -> {number_of_digits(layer, 0), layer} end)
      |> Enum.sort_by(fn {count, _} -> count end)

    number_of_digits(layer, 1) * number_of_digits(layer, 2)
  end

  @doc """
  Generates the image layers given image data and the image `width` and `height`.

  # Example

    iex> SpaceImageFormat.layers("123456789012", 3, 2)
    [[[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [0, 1, 2]]]
  """
  @spec layers(String.t(), Integer.t(), Integer.t()) :: List.t()
  def layers(string, width, height) do
    string
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(width)
    |> Enum.chunk_every(height)
  end

  @doc """
  Calculates the number of a `digit` in a given `layer`.

  # Example

    iex> SpaceImageFormat.number_of_digits([[1, 2, 3], [4, 5, 6]], 5)
    1
    iex> SpaceImageFormat.number_of_digits([[1, 1, 1], [4, 5, 1]], 1)
    4
  """
  @spec number_of_digits(List.t(), Integer.t()) :: Integer.t()
  def number_of_digits(layer, digit) do
    layer
    |> Enum.reduce(0, fn numbers, count -> count + Enum.count(numbers, &(&1 == digit)) end)
  end
end
