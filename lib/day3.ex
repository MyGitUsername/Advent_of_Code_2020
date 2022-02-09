defmodule AdventOfCode.Day3 do
  @moduledoc """
  Documentation for `AdventOfCode.Day3`.
  """

  @slope {3, 1}

  def input do
    "priv/day3/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def boolean_to_integer(true), do: 1
  def boolean_to_integer(false), do: 0

  def length do
    input()
    |> List.first()
    |> String.length()
  end

  def at_bottom(col) do
    col == length(input()) - 1
  end

  def tree?(row, col) do
    input()
    |> Enum.at(row)
    |> String.at(rem(col, length()))
    |> then(fn sym -> sym == "#" end)
  end

  def traverse(row, col, slope, tree_count) do
    total_trees = tree_count + boolean_to_integer(tree?(row, col))

    if at_bottom(row) do
      total_trees
    else
      {right, down} = slope
      traverse(row + down, col + right, slope, total_trees)
    end
  end

  def part1 do
    traverse(0, 0, @slope, 0)
  end

  def part2 do
  end
end
