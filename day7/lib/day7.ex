defmodule Day7 do
  def part1 do
    program = File.read!("input") |> String.replace("\n", "")

    permutations([0, 1, 2, 3, 4])
    |> Enum.map(fn [a, b, c, d, e] ->
      output = Intcode.run(program, [a, 0])
      output = Intcode.run(program, [b, output])
      output = Intcode.run(program, [c, output])
      output = Intcode.run(program, [d, output])
      Intcode.run(program, [e, output])
    end)
    |> Enum.max()
  end

  def part2 do
    # create named agents for each amplifier, update the input of b from a etc.

    program = File.read!("input") |> String.replace("\n", "") |> IntcodeComputer.load_program()

    IntcodeComputer.new(program, :amp_a, 5)

    IntcodeComputer.run_program(program, 0, :amp_a)

    # permutations([5, 6, 7, 8, 9])
    # |> Enum.map(fn [a, b, c, d, e] ->
    #   # Initialise amps
    #   IntcodeComputer.new(program, :amp_a, a)
    #   IntcodeComputer.new(program, :amp_b, b)
    #   IntcodeComputer.new(program, :amp_c, c)
    #   IntcodeComputer.new(program, :amp_d, d)
    #   IntcodeComputer.new(program, :amp_e, e)

    #   # run amps unitl halt

    # end)
    # |> Enum.max()
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end
