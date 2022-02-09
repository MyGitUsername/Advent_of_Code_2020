defmodule AdventOfCode.Day01 do
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

      Enum.find_value(perms, fn [x, y] ->
        Enum.find_value(list(), fn z ->
          if x + y + z == @goal, do: {x, y, z}
        end)
      end)
  end
end
