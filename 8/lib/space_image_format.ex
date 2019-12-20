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
  Given the input file for the day solves the second part of the challenge.
  """
  @spec part_two(String.t()) :: Integer.t()
  def part_two(input_file) do
    final_layer =
      input_file
      |> File.read!()
      |> String.trim()
      |> layers(@width, @height)
      |> build_final_layer()

    final_layer
    |> Enum.map(fn pixels -> Enum.map(pixels, &pixel_to_char/1) end)
    |> Enum.map(fn pixels -> IO.puts("#{pixels}") end)
  end

  defp pixel_to_char(0), do: "  "
  defp pixel_to_char(1), do: "██"
  defp pixel_to_char(2), do: "  "

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

  @doc """
  Builds the final layer given the image layers.

  # Example

    iex> SpaceImageFormat.build_final_layer([[[0, 2], [2, 2]], [[1, 1], [2, 2]], [[2, 2], [1, 2]], [[0, 0], [0, 0]]])
    [[0, 1], [1, 0]]
  """
  @spec build_final_layer(List.t()) :: List.t()
  def build_final_layer(layers) do
    height = layers |> List.first() |> length()
    width = layers |> List.first() |> List.first() |> length()
    final_layer = List.duplicate(List.duplicate(2, width), height)

    layers
    |> Enum.reduce(final_layer, fn current_layer, final_layer -> merge_layers(final_layer, current_layer) end)
  end

  @doc """
  Merges two layers, given that the first one is the top one and the second one is below the top one.
  Using the following rules:
  - If a pixel is 2 and the bottom one is either 1 or 0 then the bottom one prevails.
  - If the top pixel is either 0 or 1 no change is made.

  # Example

    iex> SpaceImageFormat.merge_layers([[2, 1], [0, 2]], [[0, 0], [1, 1]])
    [[0, 1], [0, 1]]
  """
  @spec merge_layers(List.t(), List.t()) :: List.t()
  def merge_layers(top, bottom) do
    Enum.zip(top, bottom)
    |> Enum.map(fn {top_pixels, bottom_pixels} -> merge_pixels(top_pixels, bottom_pixels) end)
  end


  @doc """
  Merges two rows of pixels.

  # Example

    iex> SpaceImageFormat.merge_pixels([2, 1], [0, 0])
    [0, 1]
  """
  @spec merge_pixels(List.t(), List.t()) :: List.t()
  def merge_pixels(top, bottom) do
    Enum.zip(top, bottom)
    |> Enum.map(fn {top_pixel, bottom_pixel} -> merge_pixel(top_pixel, bottom_pixel) end)
  end

  @doc """
  Merges two pixels, using the following rule.
  - If `top` is 2 and `bottom` is also 2 then no change is made.
  - If `top` is 2 and `bottom` is either 1 or 0, then `bottom` is returned.
  - If `top` is either 1 or 0, then top is returned.

  # Example

    iex> SpaceImageFormat.merge_pixel(2, 0)
    0
    iex> SpaceImageFormat.merge_pixel(2, 2)
    2
    iex> SpaceImageFormat.merge_pixel(1, 0)
    1
  """
  @spec merge_pixel(Integer.t(), Integer.t()) :: Integer.t()
  def merge_pixel(top, _) when top in [0, 1], do: top
  def merge_pixel(2, bottom), do: bottom
end
