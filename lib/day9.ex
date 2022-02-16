defmodule AdventOfCode.Day9 do
  @moduledoc """
  Documentation for `AdventOfCode.Day9`.
  """
  
  @preamble_len 25
  def input do
    "priv/day9/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def valid(preamble, goal) do
    preamble
    |> Enum.any?(fn cur ->
      Enum.member?(List.delete(preamble, cur), goal - cur)
    end)
  end

  def data_len, do: length(input())

  def part1 do
    Enum.to_list(@preamble_len..data_len() - 1)
    |> Enum.find_value(fn idx ->
      preamble = Enum.slice(input(), idx - @preamble_len, idx)
      goal = Enum.at(input(), idx)
      if !valid(preamble, goal), do: goal
    end)
  end

  def part2 do
  end
end
