defmodule P1 do
  @word "XMAS"
  @reverse_word String.reverse(@word)

  def check(grid, x, y, dx, dy, acc \\ "") do
    if acc == @word or acc == @reverse_word do
      1
    else
      next_x = x + dx
      next_y = y + dy

      if String.length(acc) < String.length(@word) and
           next_x < length(grid) and next_y >= 0 and
           next_y < String.length(Enum.at(grid, x)) do
        next_char = String.at(Enum.at(grid, next_x), next_y)
        check(grid, next_x, next_y, dx, dy, acc <> next_char)
      else
        0
      end
    end
  end

  def count(grid) do
    grid
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, x}, acc ->
      (acc + Enum.with_index(row))
      |> Enum.reduce(0, fn {_, y}, row_acc ->
        row_acc +
          Enum.reduce([{0, 1}, {1, 0}, {1, 1}, {1, -1}], 0, fn {dx, dy}, sum ->
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

P1.read_grid_from_file() |> P1.count() |> IO.puts()
