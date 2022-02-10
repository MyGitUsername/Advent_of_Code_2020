defmodule AdventOfCode.Day4 do
  @moduledoc """
  Documentation for `AdventOfCode.Day4`.
  """

  @ecl ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  @byr_range 1920..2002
  @iyr_range 2010..2020
  @eyr_range 2020..2030
  @inches_range 59..76
  @centimeters_range 150..193

  def input do
    "priv/day4/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.replace(&1, "\n", " "))
    |> Enum.map(&parse/1)
  end

  def parse(line) do
    line
    |> String.split([" ", ":"], trim: true)
    |> Enum.chunk_every(2)
    |> Map.new(&List.to_tuple/1)
    |> cast()
  end

  defp cast(%{"byr" => byr, "iyr" => iyr, "eyr" => eyr} = passport) do
    Map.merge(passport, %{
      "byr" => String.to_integer(byr),
      "iyr" => String.to_integer(iyr),
      "eyr" => String.to_integer(eyr)
    })
  end

  defp cast(passport), do: passport

  defp valid?({"byr", byr}), do: byr in @byr_range
  defp valid?({"iyr", iyr}), do: iyr in @iyr_range
  defp valid?({"eyr", eyr}), do: eyr in @eyr_range
  defp valid?({"ecl", ecl}), do: Enum.member?(@ecl, ecl)
  defp valid?({"pid", pid}), do: ~r/^[0-9]{9}$/ |> Regex.match?(pid)
  defp valid?({"hcl", hcl}), do: ~r/^#[0-9,a-f]{6}$/ |> Regex.match?(hcl)

  defp valid?({"hgt", hgt}) do
    case hgt do
      <<num::binary-size(2), "i", "n">> -> String.to_integer(num) in @inches_range
      <<num::binary-size(3), "c", "m">> -> String.to_integer(num) in @centimeters_range
      _ -> false
    end
  end

  defp valid?({"cid", _}), do: true

  def required_fields?(passport) do
    case map_size(passport) do
      8 -> true
      7 -> not Map.has_key?(passport, "cid")
      _ -> false
    end
  end

  def valid_fields?(passport) do
    Enum.map(passport, &valid?/1)
    |> Enum.all?()
  end

  def part1 do
    input()
    |> Enum.count(&required_fields?/1)
  end

  def part2 do
    input()
    |> Enum.count(fn pp ->
      required_fields?(pp) and valid_fields?(pp)
    end)
  end
end
