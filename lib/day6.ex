defmodule AdventOfCode.Day6 do
  @moduledoc """
  Documentation for `AdventOfCode.Day6`.
  """

  def input do
    "priv/day6/sample.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end

  def group_to_answer_set(group) do
    group
    |> Enum.flat_map(&String.graphemes/1)
    |> MapSet.new()
  end

  def answer_sets, do: groups() |> Enum.map(&group_to_answer_set/1)

  def groups, do: input() |> Enum.map(&String.split(&1, "\n", trim: true))

  def part1 do
    answer_sets()
    |> Enum.map(&MapSet.size/1)
    |> Enum.reduce(&+/2)
  end

  def part2 do
    Enum.zip(groups(), answer_sets())
    |> Enum.flat_map(fn {group, answer_set} ->
      for l <- answer_set do
        Enum.all?(group, fn person -> String.contains?(person, l) end)
      end
    end)
    |> Enum.reject(&(&1 == false))
    |> Enum.count()
  end
end
