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

  def occupied_adjacent_2(grid, {{row, col}, _}) do
    Enum.count_until(
      grid,
      fn seat ->
        coor = elem(seat, 0)

        cond do
          coor == {row + 1, col} ->
            next_occupied(grid, next_seat(grid, row, col, 1, 0), 1, 0)

          coor == {row - 1, col} ->
            next_occupied(grid, next_seat(grid, row, col, -1, 0), -1, 0)

          coor == {row + 1, col + 1} ->
            next_occupied(grid, next_seat(grid, row, col, 1, 1), 1, 1)

          coor == {row - 1, col - 1} ->
            next_occupied(grid, next_seat(grid, row, col, -1, -1), -1, -1)

          coor == {row, col + 1} ->
            next_occupied(grid, next_seat(grid, row, col, 0, 1), 0, 1)

          coor == {row, col - 1} ->
            next_occupied(grid, next_seat(grid, row, col, 0, -1), 0, -1)

          coor == {row - 1, col + 1} ->
            next_occupied(grid, next_seat(grid, row, col, -1, 1), -1, 1)

          coor == {row + 1, col - 1} ->
            next_occupied(grid, next_seat(grid, row, col, 1, -1), 1, -1)

          true ->
            false
        end
      end,
      5
    )
  end

  def occupied_adjacent_1(grid, {{row, col}, _}) do
    Enum.count_until(
      grid,
      fn pos ->
        cond do
          pos == {{row + 1, col}, @occupied} -> true
          pos == {{row - 1, col}, @occupied} -> true
          pos == {{row + 1, col + 1}, @occupied} -> true
          pos == {{row - 1, col - 1}, @occupied} -> true
          pos == {{row, col + 1}, @occupied} -> true
          pos == {{row, col - 1}, @occupied} -> true
          pos == {{row - 1, col + 1}, @occupied} -> true
          pos == {{row + 1, col - 1}, @occupied} -> true
          true -> false
        end
      end,
      4
    )
  end

  defp next_occupied(_grid, {{row, col}, _status}, _row_inc, _col_inc)
       when row < 0 or row >= @col_len or col < 0 or col >= @row_len do
    false
  end

  defp next_occupied(_grid, {{_row, _col}, @empty}, _row_inc, _col_inc), do: false
  defp next_occupied(_grid, {{_row, _col}, @occupied}, _row_inc, _col_inc), do: true

  defp next_occupied(grid, {{row, col}, @floor}, row_inc, col_inc) do
    next_occupied(grid, next_seat(grid, row, col, row_inc, col_inc), row_inc, col_inc)
  end

  defp next_seat(grid, row, col, row_inc, col_inc) do
    {{row + row_inc, col + col_inc}, grid[{row + row_inc, col + col_inc}]}
  end

  defp total_occupied(grid) do
    Enum.count(grid, fn {{_row, _col}, sym} ->
      if sym == @occupied, do: @occupied
    end)
  end

  defp transform(grid, {{_row, _col}, @empty} = seat, adjacent, _min) do
    if adjacent.(grid, seat) == 0, do: @occupied, else: @empty
  end

  defp transform(grid, {{_row, _col}, @occupied} = seat, adjacent, min) do
    if adjacent.(grid, seat) >= min, do: @empty, else: @occupied
  end

  defp transform(_grid, {{_row, _col}, @floor}, _adjacent, _min), do: @floor

  def step(grid, occupied_adjacent, min) do
    next_grid =
      Map.map(grid, fn seat ->
        transform(grid, seat, occupied_adjacent, min)
      end)

    if total_occupied(grid) == total_occupied(next_grid) do
      total_occupied(grid)
    else
      step(next_grid, occupied_adjacent, min)
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
