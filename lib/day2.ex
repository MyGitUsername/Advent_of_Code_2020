defmodule AdventOfCode.Day2 do
  @moduledoc """
  Documentation for `AdventOfCode.Day2`.
  """
  def input do
    "priv/day2/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [occurrences, char, pass] ->
      [min, max] = String.split(occurrences, "-")
      char = String.trim_trailing(char, ":")
      {String.to_integer(min), String.to_integer(max), char, pass}
    end)
  end

  def is_valid_part1?({min, max, char, pass}) do
    pass
    |> String.graphemes()
    |> Enum.frequencies()
    |> Map.get(char, -1)
    |> then(&(&1 >= min and &1 <= max))
  end

  def exclusive_or(arg1, arg2) do
    if arg1 and arg2, do: false, else: arg1 or arg2
  end

  def is_valid_part2?({min, max, char, pass}) do
    pos1 = String.at(pass, min - 1)
    pos2 = String.at(pass, max - 1)

    exclusive_or(pos1 == char, pos2 == char)
  end

  def part1 do
    input()
    |> Enum.map(&is_valid_part1?(&1))
    |> Enum.count(& &1)
  end

  def part2 do
    input()
    |> Enum.map(&is_valid_part2?(&1))
    |> Enum.count(& &1)
  end
end
