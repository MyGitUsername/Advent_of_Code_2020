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

  def rules() do
    input()
    |> Enum.map(&String.replace(&1, [" bags", " bag"], "", trim: true))
    |> Enum.map(&String.split(&1, [" contain ", ", "], trim: true))
    |> Map.new(fn [bag | contents] -> {bag, contents} end)
    |> Map.map(fn {_k, contents} ->
      Enum.map(contents, fn
        <<n::utf8, " ">> <> bag -> {bag, String.to_integer(<<n>>)}
        bag -> {bag, nil}
      end)
    end)
  end

  @doc """
  Use bread first search to traverse tree. 
  Returns a list of all visited nodes represented 
  as {node_name, number of bags current node, 
  total number of parent bags}.  Note, the total
  number of parent bags does not include the root
  node.

  For example: 
     {A, 1}
      //\
     /  \ 
  {B,2}  {C, 3}
    \
     \
     {D, 4}
     /
    / 
  {E, 5}

  This last node {E, 5} would be represented as
  {E, 5, 8} when the BFS is printed.
  """
  def bfs(start), do: bfs([start], [start])
  def bfs([], visited), do: visited

  def bfs(queue, visited) do
    {{node, num_bags, num_parents}, queue} = List.pop_at(queue, 0)

    children =
      rules()[node]
      |> Enum.reject(fn {k, _v} -> k == @no end)
      |> Enum.map(fn {k, v} -> {k, v, num_bags * num_parents} end)

    bfs(queue ++ children, visited ++ children)
  end

  def part1 do
    rules()
    |> Map.delete(@sg)
    |> Enum.map(fn {k, _v} -> bfs({k, 1, 1}) end)
    |> Enum.count(&Enum.any?(&1, fn {name, _num_bags, _num_parents} -> name == @sg end))
  end

  def part2 do
    bfs({@sg, 1, 1})
    |> Enum.reduce(0, fn {_name, num_bags, num_parents}, acc ->
      acc + num_bags * num_parents
    end)
    # subtract gold bag which contains all other bags 
    |> then(&(&1 - 1))
  end
end
