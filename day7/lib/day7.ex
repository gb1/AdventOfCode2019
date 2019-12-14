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
    # program =
    #   "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
    #   |> IntcodeComputer.load_program()

    program = File.read!("input") |> String.replace("\n", "") |> IntcodeComputer.load_program()

    permutations([5, 6, 7, 8, 9])
    |> Enum.map(fn [a, b, c, d, e] ->
      run_amps([a, b, c, d, e], program)
    end)
    |> Enum.max()
  end

  def run_amps([a, b, c, d, e], program) do
    IntcodeComputer.new(program, :amp_a)
    IntcodeComputer.new(program, :amp_b)
    IntcodeComputer.new(program, :amp_c)
    IntcodeComputer.new(program, :amp_d)
    IntcodeComputer.new(program, :amp_e)

    IntcodeComputer.set_input(:amp_a, a)
    IntcodeComputer.set_input(:amp_b, b)
    IntcodeComputer.set_input(:amp_c, c)
    IntcodeComputer.set_input(:amp_d, d)
    IntcodeComputer.set_input(:amp_e, e)

    [:amp_a, :amp_b, :amp_c, :amp_d, :amp_e]
    |> Enum.each(fn amp ->
      IntcodeComputer.run_program(
        IntcodeComputer.get_program(amp),
        IntcodeComputer.get_position(amp),
        amp
      )
    end)

    run(0)
  end

  def run(input) do
    IntcodeComputer.set_input(:amp_a, input)

    {_, output} =
      IntcodeComputer.run_program(
        IntcodeComputer.get_program(:amp_a),
        IntcodeComputer.get_position(:amp_a),
        :amp_a
      )

    IntcodeComputer.set_input(:amp_b, output)

    {_, output} =
      IntcodeComputer.run_program(
        IntcodeComputer.get_program(:amp_b),
        IntcodeComputer.get_position(:amp_b),
        :amp_b
      )

    IntcodeComputer.set_input(:amp_c, output)

    {_, output} =
      IntcodeComputer.run_program(
        IntcodeComputer.get_program(:amp_c),
        IntcodeComputer.get_position(:amp_c),
        :amp_c
      )

    IntcodeComputer.set_input(:amp_d, output)

    {_, output} =
      IntcodeComputer.run_program(
        IntcodeComputer.get_program(:amp_d),
        IntcodeComputer.get_position(:amp_d),
        :amp_d
      )

    IntcodeComputer.set_input(:amp_e, output)

    {state, output} =
      IntcodeComputer.run_program(
        IntcodeComputer.get_program(:amp_e),
        IntcodeComputer.get_position(:amp_e),
        :amp_e
      )

    case state do
      :halt ->
        Agent.stop(:amp_a)
        Agent.stop(:amp_b)
        Agent.stop(:amp_c)
        Agent.stop(:amp_d)
        Agent.stop(:amp_e)

        output

      :sleeping ->
        run(output)
    end
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end
