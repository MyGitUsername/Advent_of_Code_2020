defmodule AdventOfCode.Day10 do
  @moduledoc """
  Documentation for `AdventOfCode.Day10`.
  """

  def input do
    "priv/day10/large-sample.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  # def run_until
  def arrange([_h | t], acc) when length(t) == 1, do: acc 
  
  def arrange([h | t], acc) when h == 0, do: arrange(t, acc)

  def arrange([head | tail] = list, acc) do
    prev = head
    curr = hd(tail)
    next = Enum.at(tail, 1)
    nextnext = Enum.at(tail, 2)

    IO.inspect binding()

    # 1,2,3,4,5
    # - 3 
    res = if prev + 3 >= next do
      new_list = List.delete(tail, curr)
      arrange(new_list, 1)
    else 
      0
    end
    res2 = if prev + 3 >= nextnext do
      new_list = List.delete(tail, nextnext)
      arrange(new_list, 1)
    else 
      0 
    end
    arrange(tail, acc) + res + res2
  end

  def device_adapter, do: List.last(input()) + 3

  defp test_adapters([_ | []], acc), do: acc
  defp test_adapters([head | tail], acc), do: test_adapters(tail, [hd(tail) - head | acc])

  def part1 do
    test_adapters([0] ++ input() ++ [device_adapter()], [])
    |> then(fn list ->
      Enum.count(list, &(&1 == 3)) * Enum.count(list, &(&1 == 1))
    end)
  end

  def part2 do
    arrange([0] ++ input() ++ [device_adapter()], 0)
  end
end

# IO.inspect(binding())
# modified_list = List.delete(list, hd(tail))

# res =
#   cond do
#     Enum.at(tail, 2) <= head + 3 ->
#       modified_list_2 = List.delete(modified_list, hd(tl(modified_list)))
#       arrange(modified_list, 1) + arrange(modified_list_2, 1)

#     Enum.at(tail, 1) <=
#         head + 3 ->
#       arrange(modified_list, 1)

#     true ->
#       0
#   end
