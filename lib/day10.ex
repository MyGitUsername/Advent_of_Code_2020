defmodule AdventOfCode.Day10 do
  @moduledoc """
  Documentation for `AdventOfCode.Day10`.
  """

  def input do
    "priv/day10/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> List.insert_at(0, 0)
  end

  def device_adapter, do: List.last(input()) + 3

  defp test_adapters([_ | []], acc), do: acc
  defp test_adapters([head | tail], acc), do: test_adapters(tail, [hd(tail) - head | acc])

  def part1 do
    test_adapters(input() ++ [device_adapter()], [])
    |> then(fn list -> 
      (Enum.count(list, & &1 == 3) * Enum.count(list, & &1 == 1)) 
    end)
  end 

  def part2 do
  end
end
