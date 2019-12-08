defmodule Day8 do

  @doc """
  Chunk by dimensions to get the layers
  get the layer with least 0's and count 1's/2's in it
  """
  def part1 do
    {_count, layer} = File.read!("input")
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> Enum.chunk_every(25 * 6)
    |> Enum.map( fn(layer) ->
      {Enum.count(layer, &(&1 == "0")), layer}
    end)
    |> Enum.sort
    |> List.first

    ones = Enum.count(layer, &(&1 == "1"))
    twos = Enum.count(layer, &(&1 == "2"))

    ones * twos
  end

  @doc """
  Zip up the layers, remove the transparent 2's
  and take the first value as the pixel
  """
  def part2 do
    File.read!("input")
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> Enum.chunk_every(25 * 6)
    |> Enum.zip
    |> Enum.map( fn(layers) ->
      Tuple.to_list(layers)
      |> Enum.filter(&(&1 != "2"))
      |> List.first
    end)
    |> Enum.chunk_every(25)
    |> Enum.map(&List.to_string/1)
    |> Enum.map(&(String.replace(&1, "1", "🎄")))
    |> Enum.map(&(String.replace(&1, "0", "⬜")))
    |> Enum.each(&IO.puts/1)


  end


end
