defmodule Day7 do

  def part1 do

    program = File.read!("input") |> String.replace("\n", "")

    permutations([0,1,2,3,4])
    |> Enum.map( fn([a,b,c,d,e]) ->
      output = Intcode.run(program, [a,0])
      output = Intcode.run(program, [b,output])
      output = Intcode.run(program, [c,output])
      output = Intcode.run(program, [d,output])
      Intcode.run(program, [e,output])
    end)
    |> Enum.max


  end

  def part2 do

    # create named agents for each amplifier, update the input of b from a etc.

  end


  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

end
