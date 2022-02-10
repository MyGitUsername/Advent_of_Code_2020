defmodule AdventOfCode.Day4 do
  @moduledoc """
  Documentation for `AdventOfCode.Day4`.
  """

  @ecl ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
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
  end

  def valid_byr?(byr), do: byr >= 1920 and byr <= 2002

  def valid_iyr?(iyr), do: iyr >= 2010 and iyr <= 2020

  def valid_eyr?(eyr), do: eyr >= 2020 and eyr <= 2030

  def valid_inches?(int), do: int >= 59 and int <= 76
  
  def valid_centimeters?(int), do: int >= 150 and int <= 193

  def valid_hgt?(hgt) do
    case hgt do
      ^hgt = <<num::binary-size(2), "i", "n">> -> valid_inches?(String.to_integer(num))
      ^hgt = <<num::binary-size(3), "c", "m">> -> valid_centimeters?(String.to_integer(num))
      _ -> false
    end
  end

  def valid_hcl?(hcl), do: ~r/^#[0-9,a-f]{6}$/ |> Regex.match?(hcl) 

  def valid_ecl?(ecl), do: Enum.member?(@ecl, ecl) 

  def valid_pid?(pid), do: ~r/^[0-9]{9}$/ |> Regex.match?(pid)

  def required_fields?(passport) do
    case map_size(passport) do
      8 -> true
      7 -> not Map.has_key?(passport, "cid")
      _ -> false
    end
  end

  def valid_fields?(passport) do
    Enum.map(passport, fn
      {"byr", v} -> valid_byr?(String.to_integer(v))
      {"iyr", v} -> valid_iyr?(String.to_integer(v))
      {"eyr", v} -> valid_eyr?(String.to_integer(v))
      {"hgt", v} -> valid_hgt?(v)
      {"hcl", v} -> valid_hcl?(v)
      {"ecl", v} -> valid_ecl?(v)
      {"pid", v} -> valid_pid?(v)
      {"cid", _v} -> true
    end) 
    |> Enum.all?()
  end

  def part1 do
    input()
    |> Enum.count(&required_fields?/1)
  end

  def part2 do
    input()
    |> Enum.filter(&required_fields?/1)
    |> Enum.filter(&valid_fields?/1)
    |> Enum.count()
  end
end
