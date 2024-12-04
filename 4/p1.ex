defmodule P1 do
  @word "XMAS"
  @reverse_word String.reverse(@word)

  def check(grid, x, y, dx, dy, acc \\ "") do
    cond do
      acc == @word or acc == @reverse_word ->
        1

      String.length(acc) < String.length(@word) and x < length(grid) and y >= 0 and
          y < String.length(Enum.at(grid, x)) ->
        next_char = String.at(Enum.at(grid, x), y)
        check(grid, x + dx, y + dy, dx, dy, acc <> next_char)

      true ->
        0
    end
  end

  def count(grid) do
    grid
    |> Enum.with_index()
    |> Enum.map(fn {row, x} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.flat_map(fn {_, y} ->
        [
          check(grid, x, y, 0, 1),
          check(grid, x, y, 1, 0),
          check(grid, x, y, 1, 1),
          check(grid, x, y, 1, -1)
        ]
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def read_grid_from_file do
    "input.txt"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end
end

P1.read_grid_from_file() |> P1.count() |> IO.puts()
