defmodule AdventOfCode.Day12 do
  @moduledoc """
  Documentation for `AdventOfCode.Day12`.
  """

  def input do
    "priv/day12/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split_at(&1, 1))
    |> Enum.map(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  end

  defp rotate(:N, :L, 90), do: :W
  defp rotate(:S, :L, 90), do: :E
  defp rotate(:E, :L, 90), do: :N
  defp rotate(:W, :L, 90), do: :S
  defp rotate(:N, :L, 180), do: :S
  defp rotate(:S, :L, 180), do: :N
  defp rotate(:E, :L, 180), do: :W
  defp rotate(:W, :L, 180), do: :E
  defp rotate(:N, :L, 270), do: :E
  defp rotate(:S, :L, 270), do: :W
  defp rotate(:E, :L, 270), do: :S
  defp rotate(:W, :L, 270), do: :N

  defp rotate(:N, :R, 270), do: :W
  defp rotate(:S, :R, 270), do: :E
  defp rotate(:E, :R, 270), do: :N
  defp rotate(:W, :R, 270), do: :S
  defp rotate(:N, :R, 180), do: :S
  defp rotate(:S, :R, 180), do: :N
  defp rotate(:E, :R, 180), do: :W
  defp rotate(:W, :R, 180), do: :E
  defp rotate(:N, :R, 90), do: :E
  defp rotate(:S, :R, 90), do: :W
  defp rotate(:E, :R, 90), do: :S
  defp rotate(:W, :R, 90), do: :N

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
