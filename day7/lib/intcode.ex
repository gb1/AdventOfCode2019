defmodule Intcode do
  def run(program, input) do
    Agent.start_link(fn -> input end, name: :input)
    Agent.start_link(fn -> nil end, name: :output)

    Agent.update(:input, fn _x -> input end)
    Agent.update(:output, fn _x -> nil end)

    program
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> load_program()
    |> run_program(0)
  end

  def run_program(program, position) do
    opcode = program[position] |> parse_opcode()

    {program, position} = execute(opcode, position, program)

    case program[position] do
      99 -> Agent.get(:output, fn x -> x end)
      _ -> run_program(program, position)
    end
  end

  def load_program(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {x, y} -> {y, x} end)
    |> Enum.into(%{})
  end

  @doc """
  Execute instruction

  Addition:
  iex> Day5.execute([0,0,0,0,1], 0, %{0 => 1, 1 => 0, 2 => 0, 3 => 0, 4 => 99})
  {%{0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}, 4}

  Multiplication
  iex> Day5.execute([0,0,0,0,2], 0, %{0 => 2, 1 => 3, 2 => 0, 3 => 3, 4 => 99})
  {%{0 => 2, 1 => 3, 2 => 0, 3 => 6, 4 => 99}, 4}

  Input
  iex> Day5.execute([0,0,0,0,3], 0, %{0 => 2, 1 => 2, 2 => 0, 3 => 3, 4 => 99})
  {%{0 => 2, 1 => 2, 2 => 1, 3 => 3, 4 => 99}, 2}

  Output
  iex> Day5.execute([0,0,0,0,4], 0, %{0 => 2, 1 => 2, 2 => 0, 3 => 3, 4 => 99})
  {%{0 => 2, 1 => 2, 2 => 0, 3 => 3, 4 => 99}, 2}
  """
  def execute([0, 0, 0, 0, 1], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[program[position + 1]] + program[program[position + 2]]
     ), position + 4}
  end

  def execute([0, 0, 1, 0, 1], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[position + 1] + program[program[position + 2]]
     ), position + 4}
  end

  def execute([0, 1, 0, 0, 1], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[program[position + 1]] + program[position + 2]
     ), position + 4}
  end

  def execute([0, 1, 1, 0, 1], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[position + 1] + program[position + 2]
     ), position + 4}
  end

  def execute([0, 0, 0, 0, 2], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[program[position + 1]] * program[program[position + 2]]
     ), position + 4}
  end

  def execute([0, 0, 1, 0, 2], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[position + 1] * program[program[position + 2]]
     ), position + 4}
  end

  def execute([0, 1, 0, 0, 2], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[program[position + 1]] * program[position + 2]
     ), position + 4}
  end

  def execute([0, 1, 1, 0, 2], position, program) do
    {Map.put(
       program,
       program[position + 3],
       program[position + 1] * program[position + 2]
     ), position + 4}
  end

  def execute([_, _, _, 0, 3], position, program) do
    [input | tail] = Agent.get(:input, fn x -> x end)
    Agent.update(:input, fn _x -> tail end)

    {Map.put(program, program[position + 1], input), position + 2}
  end

  def execute([_, _, _, 0, 4], position, program) do
    # IO.inspect(program[program[position + 1]])
    Agent.update(:output, fn _x -> program[program[position + 1]] end)
    {program, position + 2}
  end

  # Jump if true
  def execute([_, 0, 0, 0, 5], position, program) do
    case program[program[position + 1]] do
      0 -> {program, position + 3}
      _ -> {program, program[program[position + 2]]}
    end
  end

  def execute([_, 0, 1, 0, 5], position, program) do
    case program[position + 1] do
      0 -> {program, position + 3}
      _ -> {program, program[program[position + 2]]}
    end
  end

  def execute([_, 1, 0, 0, 5], position, program) do
    case program[program[position + 1]] do
      0 -> {program, position + 3}
      _ -> {program, program[position + 2]}
    end
  end

  def execute([_, 1, 1, 0, 5], position, program) do
    case program[position + 1] do
      0 -> {program, position + 3}
      _ -> {program, program[position + 2]}
    end
  end

  # Jump if false
  def execute([_, 0, 0, 0, 6], position, program) do
    case program[program[position + 1]] do
      0 -> {program, program[program[position + 2]]}
      _ -> {program, position + 3}
    end
  end

  def execute([_, 0, 1, 0, 6], position, program) do
    case program[position + 1] do
      0 -> {program, program[program[position + 2]]}
      _ -> {program, position + 3}
    end
  end

  def execute([_, 1, 0, 0, 6], position, program) do
    case program[program[position + 1]] do
      0 -> {program, program[position + 2]}
      _ -> {program, position + 3}
    end
  end

  def execute([_, 1, 1, 0, 6], position, program) do
    case program[position + 1] do
      0 -> {program, program[position + 2]}
      _ -> {program, position + 3}
    end
  end

  # Less than
  def execute([_, 0, 0, 0, 7], position, program) do
    cond do
      program[program[position + 1]] < program[program[position + 2]] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  def execute([_, 0, 1, 0, 7], position, program) do
    cond do
      program[position + 1] < program[program[position + 2]] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  def execute([_, 1, 0, 0, 7], position, program) do
    cond do
      program[program[position + 1]] < program[position + 2] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  def execute([_, 1, 1, 0, 7], position, program) do
    cond do
      program[position + 1] < program[position + 2] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  # Equal
  def execute([_, 0, 0, 0, 8], position, program) do
    cond do
      program[program[position + 1]] == program[program[position + 2]] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  def execute([0, 0, 1, 0, 8], position, program) do
    cond do
      program[position + 1] == program[program[position + 2]] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  def execute([_, 1, 0, 0, 8], position, program) do
    cond do
      program[program[position + 1]] == program[position + 2] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  def execute([_, 1, 1, 0, 8], position, program) do
    cond do
      program[position + 1] == program[position + 2] ->
        {Map.put(
           program,
           program[position + 3],
           1
         ), position + 4}

      true ->
        {Map.put(
           program,
           program[position + 3],
           0
         ), position + 4}
    end
  end

  @doc """
  Parse an integer opcode into a list for pattern matching

  iex> Day5.parse_opcode(1002)
  [0,1,0,0,2]

  iex> Day5.parse_opcode(99)
  [0,0,0,9,9]
  """
  def parse_opcode(opcode) do
    (opcode + 100_000)
    |> Integer.to_string()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.delete(1)
  end
end
