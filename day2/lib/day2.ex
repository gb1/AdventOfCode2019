defmodule Day2 do

  @input [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,13,19,23,2,23,9,27,1,6,27,31,2,10,31,35,1,6,35,39,2,9,39,43,1,5,43,47,2,47,13,51,2,51,10,55,1,55,5,59,1,59,9,63,1,63,9,67,2,6,67,71,1,5,71,75,1,75,6,79,1,6,79,83,1,83,9,87,2,87,10,91,2,91,10,95,1,95,5,99,1,99,13,103,2,103,9,107,1,6,107,111,1,111,5,115,1,115,2,119,1,5,119,0,99,2,0,14,0]

  def part1 do
    @input
    |> create_program
    |> Map.update!(1, fn(_) -> 12 end)
    |> Map.update!(2, fn(_) -> 2 end)
    |> execute(0)
    |> Map.get(0)
  end

  def part2 do

    results =
    for noun <- 0..99 do
      for verb <- 0..99 do

        output = @input
        |> create_program
        |> Map.update!(1, fn(_) -> noun end)
        |> Map.update!(2, fn(_) -> verb end)
        |> execute(0)
        |> Map.get(0)

        if output == 19690720 do
          [100 * noun + verb]
        else
          "🔥"
        end
      end
    end

    results
    |> List.flatten
    |> Enum.reject( &(&1 == "🔥"))
    |> List.first
  end

  @doc """
  Create a map to represent the program

      iex> Day2.create_program([1,0,0,0,99])
      %{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}

  """
  def create_program(input) do

    input
    |> Enum.with_index
    |> Enum.map( fn({x,y}) -> {y,x} end)
    |> Enum.into(%{})

  end

  @doc """
  Execute instructions recursively until the program halts on a 99 opcode

      iex> Day2.execute(%{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99}, 0)
      %{0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}

      iex> Day2.execute(%{0 => 1, 1 => 1, 2 => 1, 3 => 4, 4 => 99, 5 => 5, 6 => 6, 7 => 0, 8 => 99}, 0)
      %{0 => 30, 1 => 1, 2 => 1, 3 => 4, 4 => 2, 5 => 5, 6 => 6, 7 => 0, 8 => 99}
  """
  def execute( program, opcode )  do

    if program[opcode] == 99 do
      program
    else
      program
      |> Map.update!( program[opcode+3], fn(_)->
        case program[opcode] do
          1 -> program[program[opcode+1]] + program[program[opcode+2]]
          2 -> program[program[opcode+1]] * program[program[opcode+2]]
        end
      end)
      |> execute(opcode + 4)
    end
  end
end
