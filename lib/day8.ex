defmodule AdventOfCode.Day8 do
  @moduledoc """
  Documentation for `AdventOfCode.Day8`.
  """

  def input do
    "priv/day8/input.txt"
    |> File.read!()
    |> String.split(["\n", " "], trim: true)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.map(fn {op, arg} -> {String.to_atom(op), String.to_integer(arg)} end)
  end

  defp execute({:nop, _}), do: {1, 0}
  defp execute({:acc, add_to_acc}), do: {1, add_to_acc}
  defp execute({:jmp, offset}), do: {offset, 0}

  defp run(list), do: run(list, 0, [], 0)
  defp run(instructions, pos, _visited, acc) when pos == length(instructions), do: {:ok, acc}

  defp run(instructions, pos, visited, acc) do
    instruct = Enum.at(instructions, pos)

    if Enum.member?(visited, pos) do
      {:error, acc}
    else
      {offset, add_to_acc} = execute(instruct)
      run(instructions, pos + offset, [pos | visited], acc + add_to_acc)
    end
  end

  defp test_modified_instructions({{op, _arg}, idx}) do
    op = if op == :jmp, do: :nop, else: :jmp
    {_, value} = Enum.at(input(), idx)
    modified_list = List.replace_at(input(), idx, {op, value})

    case run(modified_list) do
      {:ok, acc} -> acc
      {:error, _acc} -> :error
    end
  end

  def part1, do: run(input())

  def part2 do
    input()
    |> Enum.with_index()
    |> Enum.filter(fn {{op, _arg}, _idx} -> op == :jmp or op == :nop end)
    |> Enum.map(&test_modified_instructions(&1))
    |> Enum.reject(&(&1 == :error))
  end
end
