defmodule AdventOfCode.Day7 do
  @moduledoc """
  Documentation for `AdventOfCode.Day7`.
  """

  def input do
    "priv/day7/input.txt"
    |> File.read!()
    |> String.split(".\n", trim: true)
  end

  def rules do
    input()
    |> Enum.map(&String.replace(&1, [" bags", " bag"], "", trim: true))
    |> Enum.map(&String.split(&1, [" contain ", ", "], trim: true))
    |> Map.new(fn [bag | contents] -> {bag, contents} end)
  end

  def contain_gold?("no other"), do: false
  def contain_gold?("shiny gold"), do: true
  def contain_gold?(<<_n::utf8, " ">> <> bags), do: contain_gold?(bags)
  def contain_gold?(bags) when is_binary(bags), do: contain_gold?(rules()[bags])
  def contain_gold?([head | []]), do: contain_gold?(head)
  def contain_gold?([head | tail]), do: contain_gold?(head) or contain_gold?(tail)

  def sum_bags("shiny gold"), do: sum_bags("shiny gold", 0)
  def sum_bags("no other", sum), do: sum
  def sum_bags(<<n::utf8, " ">> <> bags, sum), do: sum_bags(bags, sum + n)
  def sum_bags(bags, sum) when is_binary(bags), do: sum_bags(rules()[bags], sum)
  def sum_bags([head | []], sum), do: sum_bags(head, sum)
  def sum_bags([head | tail], sum), do: sum_bags(head, sum) or sum_bags(tail, sum)

  def part1 do
    rules()
    |> Enum.map(fn {k, _v} -> if k != "shiny gold", do: contain_gold?(k) end)
    |> Enum.count(&(&1 == true))
  end

  def part2 do
  end
end
