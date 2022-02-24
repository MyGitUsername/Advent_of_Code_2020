defmodule AdventOfCode.Day11 do
  @moduledoc """
  Documentation for `AdventOfCode.Day11`.
  """

  @floor 46
  @empty 76
  @occupied 35
  @col_len 91
  @row_len 96

  def input do
    "priv/day11/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  defp occupied_adjacent_2(grid, {{row, col}, _}) do
    [{1, 0}, {-1, 0}, {1, 1}, {-1, -1}, {0, 1}, {0, -1}, {-1, 1}, {1, -1}]
    |> Enum.filter(fn {row_inc, col_inc} ->
      occupied?(grid, next_seat(grid, row, col, row_inc, col_inc), row_inc, col_inc)
    end)
    |> Enum.count_until(5)
  end

  defp occupied_adjacent_1(grid, {{row, col}, _}) do
    [
      {{row + 1, col}, @occupied},
      {{row - 1, col}, @occupied},
      {{row + 1, col + 1}, @occupied},
      {{row - 1, col - 1}, @occupied},
      {{row, col + 1}, @occupied},
      {{row, col - 1}, @occupied},
      {{row - 1, col + 1}, @occupied},
      {{row + 1, col - 1}, @occupied}
    ]
    |> Enum.filter(fn adjacent -> Enum.member?(grid, adjacent) end)
    |> Enum.count_until(4)
  end

  defp occupied?(_grid, {{row, col}, _status}, _row_inc, _col_inc)
       when row < 0 or row >= @col_len or col < 0 or col >= @row_len do
    false
  end

  defp occupied?(_grid, {{_row, _col}, @empty}, _row_inc, _col_inc), do: false
  defp occupied?(_grid, {{_row, _col}, @occupied}, _row_inc, _col_inc), do: true

  defp occupied?(grid, {{row, col}, @floor}, row_inc, col_inc) do
    occupied?(grid, next_seat(grid, row, col, row_inc, col_inc), row_inc, col_inc)
  end

  defp next_seat(grid, row, col, row_inc, col_inc) do
    {{row + row_inc, col + col_inc}, grid[{row + row_inc, col + col_inc}]}
  end

  defp total_occupied(grid) do
    Enum.count(grid, fn {{_row, _col}, status} ->
      if status == @occupied, do: true
    end)
  end

  defp transform(grid, {{_row, _col}, @empty} = seat, num_occupied_adjacent, _min) do
    if num_occupied_adjacent.(grid, seat) == 0, do: @occupied, else: @empty
  end

  defp transform(grid, {{_row, _col}, @occupied} = seat, num_occupied_adjacent, min) do
    if num_occupied_adjacent.(grid, seat) >= min, do: @empty, else: @occupied
  end

  defp transform(_grid, {{_row, _col}, @floor}, _num_occupied_adjacent, _min), do: @floor

  defp step(grid, strategy, min) do
    next_grid =
      Map.map(grid, fn seat ->
        transform(grid, seat, strategy, min)
      end)

    if total_occupied(grid) == total_occupied(next_grid) do
      total_occupied(grid)
    else
      step(next_grid, strategy, min)
    end
  end

  def grid do
    for {line, row} <- Enum.with_index(input()),
        {sym, col} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{row, col}, sym}
    end
  end

  def part1, do: step(grid(), &occupied_adjacent_1/2, 4)

  def part2, do: step(grid(), &occupied_adjacent_2/2, 5)
end
