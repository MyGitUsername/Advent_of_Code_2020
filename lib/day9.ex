defmodule AdventOfCode.Day9 do
  @moduledoc """
  Documentation for `AdventOfCode.Day9`.
  """

  @preamble_len 25
  @goal 70_639_851
  @goal_idx 561

  def input do
    "priv/day9/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp valid?(preamble, goal) do
    preamble
    |> Enum.any?(fn cur ->
      Enum.member?(List.delete(preamble, cur), goal - cur)
    end)
  end

  defp data_len, do: length(input())

  defp contiguous_set(idx) do
    list = Enum.slice(input(), idx, @goal_idx - 1)

    res =
      Enum.reduce_while(list, 0, fn x, acc ->
        case acc do
          ^acc = @goal ->
            last = Enum.find_index(input(), &(&1 == x)) - idx
            run = Enum.slice(input(), idx, last)
            {:halt, {:found, run}}

          _ ->
            {:cont, acc + x}
        end
      end)

    case res do
      {:found, run} -> run
      _ -> nil
    end
  end

  def part1 do
    Enum.to_list(@preamble_len..(data_len() - 1))
    |> Enum.find_value(fn idx ->
      preamble = Enum.slice(input(), idx - @preamble_len, idx)
      goal = Enum.at(input(), idx)
      if !valid?(preamble, goal), do: goal
    end)
  end

  def part2 do
    Enum.to_list(0..(@goal_idx - 1))
    |> Enum.find_value(&contiguous_set/1)
    |> then(&(Enum.min(&1) + Enum.max(&1)))
  end
end
