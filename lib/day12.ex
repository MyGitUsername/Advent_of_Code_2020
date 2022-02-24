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

  def rotate_waypoint(waypoint, side, degrees) do
    Enum.map(waypoint, fn {dir, pos} ->
      new_dir = rotate(dir, side, degrees)
      {new_dir, pos}
    end)
  end

  def move_forward(waypoint, position, units) do
    Enum.map(position, fn {dir, pos} ->
      {dir, pos + waypoint[dir] * units}
    end)
  end

  def part1 do
    Enum.reduce(input(), %{E: 0, W: 0, N: 0, S: 0, dir: :E}, fn {action, value}, instrct ->
      case action do
        :N -> Map.update!(instrct, :N, &(&1 + value))
        :S -> Map.update!(instrct, :S, &(&1 + value))
        :E -> Map.update!(instrct, :E, &(&1 + value))
        :W -> Map.update!(instrct, :W, &(&1 + value))
        :F -> Map.update!(instrct, instrct.dir, &(&1 + value))
        :L -> %{instrct | dir: rotate(instrct.dir, :L, value)}
        :R -> %{instrct | dir: rotate(instrct.dir, :R, value)}
      end
    end)
    |> then(fn map -> abs(map[:S] - map[:N]) + abs(map[:E] - map[:W]) end)
  end

  def part2 do
    Enum.reduce(
      input(),
      %{waypoint: %{E: 10, W: 0, N: 1, S: 0}, position: %{E: 0, W: 0, N: 0, S: 0}},
      fn {action, value}, instrct ->
        case action do
          :N -> update_in(instrct, [:waypoint, :N], &(&1 + value))
          :S -> update_in(instrct, [:waypoint, :S], &(&1 + value))
          :E -> update_in(instrct, [:waypoint, :E], &(&1 + value))
          :W -> update_in(instrct, [:waypoint, :W], &(&1 + value))
          :F -> %{instrct | position: move_forward(instrct.waypoint, instrct.position, value)}
          :L -> %{instrct | waypoint: rotate_waypoint(instrct.waypoint, :L, value)}
          :R -> %{instrct | waypoint: rotate_waypoint(instrct.waypoint, :R, value)}
        end
      end
    )
    |> then(fn map ->
      abs(map.position[:S] - map.position[:N]) + abs(map.position[:E] - map.position[:W])
    end)
  end
end
