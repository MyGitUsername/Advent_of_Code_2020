defmodule AdventOfCode.Day12 do
  @moduledoc """
  Documentation for `AdventOfCode.Day12`.
  """

  @ninety_degrees_left %{N: :W, S: :E, E: :N, W: :S}
  @ninety_degrees_right %{N: :E, S: :W, E: :S, W: :N}
  @one_hundred_eighty_degrees %{N: :S, S: :N, E: :W, W: :E}

  def input do
    "priv/day12/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  end

  defp rotate(dir, :L, 90), do: @ninety_degrees_left[dir]
  defp rotate(dir, :R, 270), do: @ninety_degrees_left[dir]

  defp rotate(dir, :L, 180), do: @one_hundred_eighty_degrees[dir]
  defp rotate(dir, :R, 180), do: @one_hundred_eighty_degrees[dir]

  defp rotate(dir, :L, 270), do: @ninety_degrees_right[dir]
  defp rotate(dir, :R, 90), do: @ninety_degrees_right[dir]

  def part1 do
    Enum.reduce(input(), %{E: 0, W: 0, N: 0, S: 0, dir: :E}, fn {k, v}, instrct ->
      case k do
        :N -> Map.update!(instrct, :N, &(&1 + v))
        :S -> Map.update!(instrct, :S, &(&1 + v))
        :E -> Map.update!(instrct, :E, &(&1 + v))
        :W -> Map.update!(instrct, :W, &(&1 + v))
        :F -> Map.update!(instrct, instrct.dir, &(&1 + v))
        :L -> %{instrct | dir: rotate(instrct.dir, :L, v)}
        :R -> %{instrct | dir: rotate(instrct.dir, :R, v)}
      end
    end)
    |> then(fn map -> abs(map[:S] - map[:N]) + abs(map[:E] - map[:W]) end)
  end

  def part2 do
  end
end
