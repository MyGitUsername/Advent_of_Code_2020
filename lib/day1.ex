defmodule AdventOfCode.Day1 do
  @moduledoc """
  Documentation for `AdventOfCode.Day1`.
  """
  @goal 2020

  def list do
    "priv/day1/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def compliments do
    Enum.map(list(), fn li -> @goal - li end)
  end

  def part1 do
    Enum.filter(list(), &Enum.any?(compliments(), fn cmp -> cmp == &1 end))
  end

  def part2 do
    perms = for x <- list(), y <- list(), x + y < @goal, do: [x, y]
    three_sum = &(if &1 + &2 + &3 == @goal, do: &1 * &2 * &3)

    Enum.find_value(perms, fn [x, y] ->
      Enum.find_value(list(), fn z -> three_sum.(x, y, z) end)
    end)
  end
end
