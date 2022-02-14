defmodule AdventOfCode.Day7 do
  @moduledoc """
  Documentation for `AdventOfCode.Day7`.
  """

  @sg "shiny gold"
  @no "no other"

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

  def contain_gold?(@no), do: false
  def contain_gold?(@sg), do: true
  def contain_gold?(<<_n::utf8, " ">> <> bags), do: contain_gold?(bags)
  def contain_gold?(bags) when is_binary(bags), do: contain_gold?(rules()[bags])
  def contain_gold?([head | []]), do: contain_gold?(head)
  def contain_gold?([head | tail]), do: contain_gold?(head) or contain_gold?(tail)

  def traverse(@no, acc), do: acc
  def traverse(@sg, acc), do: List.insert_at(acc, 0, @sg)
  def traverse(<<_n::utf8, " ">> <> bags, acc), do: traverse(bags, acc)
  def traverse(bags, acc) when is_binary(bags) do
    traverse(rules()[bags], List.insert_at(acc, 0, bags))
  end
  def traverse([head | []], acc) do 
    traverse(head, acc)
  end
  def traverse([head | tail], acc) do
    traverse(head, acc) ++ traverse(tail, acc)
  end

  def part1_version_two do
    rules()
    |> Map.delete(@sg)
    |> Enum.map(fn {k, _v} -> traverse(k, []) end)
    |> IO.inspect()
    |> Enum.count(&Enum.any?(&1, fn x -> x == @sg end))
  end

  def part1 do
    rules()
    |> Enum.map(fn {k, _v} -> if k != @sg, do: contain_gold?(k) end)
    |> Enum.count(&(&1 == true))
  end

  def part2 do
  end
end
AdventOfCode.Day7.part1() |> IO.inspect
