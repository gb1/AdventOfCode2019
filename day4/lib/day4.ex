defmodule Day4 do
  def part1 do
    for n <- 240_298..784_956, is_valid?(n) do
      n
    end
    |> length
  end

  def part2 do
    for n <- 240_298..784_956, is_valid?(n), contains_a_double?(n) do
      n
    end
    |> length
  end

  def is_valid?(password) do
    password = Integer.to_string(password)

    password =
      password
      |> String.split("", trim: true)

    sorted =
      password
      |> Enum.sort()

    deduped =
      sorted
      |> Enum.uniq()

    sorted == password && length(deduped) != length(password)
  end

  def contains_a_double?(password) do
    doubles =
      password
      |> Integer.to_string()
      |> String.split("", trim: true)
      |> Enum.group_by(& &1)
      |> Enum.filter(fn {_k, v} -> length(v) == 2 end)

    doubles != []
  end
end
