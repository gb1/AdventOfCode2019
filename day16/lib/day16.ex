defmodule Day16 do
  @moduledoc """
  Day 16
  """
  @base_pattern [0, 1, 0, -1]

  def part1 do
    File.read!("input")
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> run_fft(100)
    |> Enum.take(8)
    |> Enum.map(&Integer.to_string/1)
    |> List.to_string()
  end

  def part2 do
    "03036732577212944063491565474664"
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def run_fft(signal, 0), do: signal

  def run_fft(signal, phases) do
    run_fft(fft_phase(signal), phases - 1)
  end

  @doc """
  ## Examples
      iex>  Day16.generate_base_pattern(3,11)
      [0, 0, 1, 1, 1, 0, 0, 0, -1, -1, -1]

      iex>  Day16.generate_base_pattern(1,8)
      [1, 0, -1, 0, 1, 0, -1, 0]

      iex>  Day16.generate_base_pattern(2,8)
      [0, 1, 1, 0, 0, -1, -1, 0]
  """
  def generate_base_pattern(element, take) do
    for _ <- 1..element do
      @base_pattern
    end
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten()
    |> Stream.cycle()
    |> Enum.take(take + 1)
    |> Enum.drop(1)
  end

  @doc """
  ## Examples
      iex>  Day16.fft_phase([1, 2, 3, 4, 5, 6, 7, 8])
      [4, 8, 2, 2, 6, 1, 5, 8]
  """
  def fft_phase(signal) do
    for n <- 1..length(signal) do
      generate_base_pattern(n, length(signal))
    end
    |> Enum.map(fn b ->
      Enum.zip(b, signal)
      |> Enum.map(fn {x, y} ->
        x * y
      end)
      |> Enum.sum()
      |> abs
      |> Integer.to_string()
      |> String.split("", trim: true)
      |> List.last()
      |> String.to_integer()
    end)
  end
end
