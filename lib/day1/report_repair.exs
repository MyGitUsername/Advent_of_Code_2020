defmodule AdventOfCode.Day01 do
  def list do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def compliments do
    Enum.map(list(), fn li -> 2020 - li end)
  end

  def part1 do
    Enum.filter(list(), &Enum.any?(compliments(), fn cmp -> cmp == &1 end))
  end

  def part2 do
    perms = for x <- list(), y <- list(), x + y < 2020, do: [x, y]

      Enum.find_value(perms, fn [x, y] ->
        Enum.find_value(list(), fn z ->
          if x + y + z == 2020, do: {x, y, z}
        end)
      end)
  end
end

IO.inspect(AdventOfCode.Day01.part1())
IO.inspect(AdventOfCode.Day01.part2())

