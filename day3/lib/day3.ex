defmodule Day3 do
  #########################################################################
  ### 🎄🎄🎄🎄 PART 1 🎄🎄🎄🎄🎄
  #########################################################################
  def part1() do
    [line1, line2] =
      File.read!("input")
      |> String.split("\n", trim: true)

    set1 = get_points_for_line(line1)
    set2 = get_points_for_line(line2)

    get_closest_intersecting_point_distance(set1, set2)
  end

  def get_closest_intersecting_point_distance(set1, set2) do
    MapSet.intersection(set1, set2)
    |> Enum.reject(&(&1 == {0, 0}))
    |> Enum.reduce(fn {x, y}, acc ->
      distance = manhattan_distance({x, y}, {0, 0})

      if distance < acc do
        distance
      else
        acc
      end
    end)
  end

  def get_points_for_line(line) do
    {points, _position} =
      line
      |> String.split(",")
      |> Enum.reduce({[], {0, 0}}, fn x, acc ->
        {all_points, position} = acc

        points = points_for_move(x, position)

        {all_points ++ points, List.last(points)}
      end)

    MapSet.new(points)
  end

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def points_for_move("U" <> steps, {x, y}) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x + n, y}
  end

  def points_for_move("D" <> steps, {x, y}) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x - n, y}
  end

  def points_for_move("L" <> steps, {x, y}) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x, y - n}
  end

  def points_for_move("R" <> steps, {x, y}) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x, y + n}
  end

  #########################################################################
  ### 🎅🎅🎅🎅🎅🎅 PART 2 🎅🎅🎅🎅🎅🎅
  #########################################################################
  def part2() do
    [line1, line2] =
      File.read!("input")
      |> String.split("\n", trim: true)

    # get sets for both line points as per part 1
    set1 = get_points_for_line(line1)
    set2 = get_points_for_line(line2)

    # get step counts for all points
    steps1 = get_points_for_line_with_step_count(line1)
    steps2 = get_points_for_line_with_step_count(line2)

    # for each intersection calculate the total step count
    MapSet.intersection(set1, set2)
    |> Enum.reject(&(&1 == {0, 0}))
    |> Enum.map(fn {x, y} ->
      steps1[{x, y}] + steps2[{x, y}]
    end)
    |> Enum.sort()
    |> List.first()
  end

  def get_points_for_line_with_step_count(line) do
    {points, _position, _steps} =
      line
      |> String.split(",")
      |> Enum.reduce({[], {0, 0}, 0}, fn x, acc ->
        {all_points, position, steps} = acc

        points = points_for_move(x, position, steps)

        {pos_x, pos_y, steps} = List.last(points)
        position = {pos_x, pos_y}

        {all_points ++ points, position, steps}
      end)

    # convert into a map of point => steps
    points
    |> Enum.map(fn {x, y, steps} ->
      {{x, y}, steps}
    end)
    |> Enum.into(%{})
  end

  def points_for_move("U" <> steps, {x, y}, step_count) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x + n, y, step_count + n}
  end

  def points_for_move("D" <> steps, {x, y}, step_count) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x - n, y, step_count + n}
  end

  def points_for_move("L" <> steps, {x, y}, step_count) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x, y - n, step_count + n}
  end

  def points_for_move("R" <> steps, {x, y}, step_count) do
    steps = String.to_integer(steps)

    for n <- 0..steps, do: {x, y + n, step_count + n}
  end
end
