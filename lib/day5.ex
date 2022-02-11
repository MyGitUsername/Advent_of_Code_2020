defmodule AdventOfCode.Day5 do
  @moduledoc """
  Documentation for `AdventOfCode.Day5`.

  Note: bsp stands for binary space partition
  """

  @row_range 0..127
  @col_range 0..7

  def input do
    "priv/day5/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def mid(first..last), do: div(first + last, 2)

  def seat("F" <> tail, first.._last = range), do: seat(tail, first..mid(range))
  def seat("L" <> tail, first.._last = range), do: seat(tail, first..mid(range))
  def seat("B" <> tail, _first..last = range), do: seat(tail, (mid(range) + 1)..last)
  def seat("R" <> tail, _first..last = range), do: seat(tail, (mid(range) + 1)..last)
  def seat("", first.._last), do: first

  def seat_ids do
    input()
    |> Enum.map(&String.split_at(&1, 7))
    |> Enum.map(fn {row_bsp, col_bsp} ->
      row = seat(row_bsp, @row_range)
      col = seat(col_bsp, @col_range)
      row * 8 + col
    end)
  end

  def part1, do: seat_ids() |> Enum.max()

  def part2 do
    seat_ids()
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.find(nil, fn [e1, e2] -> e2 - e1 == 2 end)
    |> then(fn [e1, _e2] -> e1 + 1 end)
  end
end
