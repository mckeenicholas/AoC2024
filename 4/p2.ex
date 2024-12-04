defmodule P2 do
  @word "MAS"
  @reverse_word String.reverse(@word)

  def check(grid, x, y, dx, dy, acc \\ "") do
    cond do
      acc == @word or acc == @reverse_word ->
        1

      String.length(acc) < String.length(@word) and
        x < length(grid) and y >= 0 and y < String.length(Enum.at(grid, x)) ->
        next_char = String.at(Enum.at(grid, x), y)
        check(grid, x + dx, y + dy, dx, dy, acc <> next_char)

      true ->
        0
    end
  end

  def count(grid) do
    directions = [{1, 1}, {1, -1}]

    grid
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, x}, acc ->
      (acc + Enum.with_index(row))
      |> Enum.reduce(0, fn {_, y}, count ->
        count +
          Enum.reduce(directions, 0, fn {dx, dy}, sum ->
            sum + check(grid, x, y, dx, dy)
          end)
      end)
    end)
  end

  def read_grid_from_file do
    "input.txt"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end
end

P2.read_grid_from_file() |> P2.count() |> IO.puts()
