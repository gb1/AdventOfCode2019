defmodule Day1 do
  def part1 do
    File.read!("lib/input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> sum
  end

  def part2 do
    File.read!("lib/input")
    |> String.split("\n", trim: true)
    |> Enum.map( fn(x) ->
      sum_fuel([String.to_integer(x)])
    end)
    |> Enum.sum
  end

  @doc """

    iex> Day1.sum([12])
    2.0
    iex> Day1.sum([100756])
    33583.0
  """
  def sum(modules) do
    modules
    |> Enum.reduce(0, fn x, acc ->
      acc + (:math.floor(x / 3) - 2)
    end)
  end

  @doc """

    iex> Day1.sum_fuel([12])
    2.0
    iex> Day1.sum_fuel([1969])
    966.0

  """
  def sum_fuel(input) do
    [head | _tail] = input
    fuel = :math.floor(head / 3) - 2

    if fuel > 0 do
      sum_fuel([fuel | input])
    else
      input |> Enum.drop(-1) |> Enum.sum
    end
  end
end
