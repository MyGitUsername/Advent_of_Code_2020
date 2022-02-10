defmodule AdventOfCode.Day4 do
  @moduledoc """
  Documentation for `AdventOfCode.Day4`.
  """

  def input do
    "priv/day4/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.replace(&1, "\n", " "))
    |> Enum.map(&parse/1)
  end

  def parse(line) do
    line
    |> String.split([" ", ":"], trim: true)
    |> Enum.chunk_every(2)
    |> Map.new(&List.to_tuple/1)
  end

  def required_fields?(passport) do
    case map_size(passport) do
      8 -> true
      7 -> not Map.has_key?(passport, "cid")
      _ -> false
    end
  end

  def part1 do
    input()
    |> Enum.count(&required_fields?/1)
  end

  def part2 do
  end
end
