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

  def lower_half(dividend), do: div(dividend, 2)
  def upper_half(dividend), do: round(dividend / 2)

  def seat(<<char::utf8>>, first..last) do
    case char do
      ?F -> first
      ?L -> first
      ?R -> last
      ?B -> last
    end
  end

  def seat(<<head, tail::binary>>, first..last) do
    mid = first + last

    case head do
      ?F -> seat(tail, first..lower_half(mid))
      ?L -> seat(tail, first..lower_half(mid))
      ?B -> seat(tail, upper_half(mid)..last)
      ?R -> seat(tail, upper_half(mid)..last)
    end
  end

  def part1 do
    input()
    |> Enum.map(&String.split_at(&1, 7))
    |> Enum.map(fn {row_bsp, col_bsp} ->
      row = seat(row_bsp, @row_range)
      col = seat(col_bsp, @col_range)
      row * 8 + col
    end)
    |> Enum.max()
  end

  def part2 do
  end
end
