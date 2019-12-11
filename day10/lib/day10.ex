defmodule Day10 do
  def part1 do
    map =
      """
      ##.#..#..###.####...######
      #..#####...###.###..#.###.
      ..#.#####....####.#.#...##
      .##..#.#....##..##.#.#....
      #.####...#.###..#.##.#..#.
      ..#..#.#######.####...#.##
      #...####.#...#.#####..#.#.
      .#..#.##.#....########..##
      ......##.####.#.##....####
      .##.#....#####.####.#.####
      ..#.#.#.#....#....##.#....
      ....#######..#.##.#.##.###
      ###.#######.#..#########..
      ###.#.#..#....#..#.##..##.
      #####.#..#.#..###.#.##.###
      .#####.#####....#..###...#
      ##.#.......###.##.#.##....
      ...#.#.#.###.#.#..##..####
      #....#####.##.###...####.#
      #.##.#.######.##..#####.##
      #.###.##..##.##.#.###..###
      #.####..######...#...#####
      #..#..########.#.#...#..##
      .##..#.####....#..#..#....
      .###.##..#####...###.#.#.#
      .##..######...###..#####.#
      """
      |> Day10.parse_map()

    asteroids =
      map
      |> Enum.reject(fn {_k, v} ->
        v == "."
      end)

    asteroids
    |> Enum.map(fn {asteroid, _} ->
      other_asteroids_in_sight(map, asteroid)
    end)
    |> Enum.max()
  end

  def parse_map(input) do
    {map, _point} =
      input
      |> String.split("", trim: true)
      |> Enum.reduce({%{}, {0, 0}}, fn x, acc ->
        {map, point} = acc
        create_point(x, map, point)
      end)

    map
  end

  def other_asteroids_in_sight(map, {x, y}) do
    asteroids =
      map
      |> Enum.reject(fn {k, v} ->
        v == "." || k == {x, y}
      end)

    asteroids
    |> Enum.map(fn {{x2, y2}, _v} ->
      heading =
        cond do
          x2 < x && y2 < y -> :NW
          x2 > x && y2 < y -> :NE
          x2 == x && y2 < y -> :N
          x2 == x && y2 > y -> :S
          x2 < x && y2 == y -> :W
          x2 > x && y2 == y -> :E
          x2 < x && y2 > y -> :SE
          x2 > x && y2 > y -> :SW
          true -> :X
        end

      {heading, slope({x, y}, {x2, y2})}
    end)
    |> Enum.uniq()
    |> length
  end

  def slope({x, _y1}, {x, _y2}), do: 0

  def slope({x1, y1}, {x2, y2}) do
    (y1 - y2) / (x1 - x2)
  end

  def create_point("\n", map, {_x, y}) do
    {map, {0, y + 1}}
  end

  def create_point(marker, map, {x, y}) do
    {Map.put(map, {x, y}, marker), {x + 1, y}}
  end

  def neighbours(map, {x, y}) do
    neighbours =
      for n <- (x - 1)..(x + 1), n >= 0 do
        for m <- (y - 1)..(y + 1), m >= 0 do
          {n, m}
        end
      end
      |> List.flatten()
      |> Enum.reject(&(&1 == {x, y}))

    Enum.filter(map, fn {k, _v} ->
      Enum.member?(neighbours, k)
    end)
    |> Enum.into(%{})

    # |> Map.drop({x, y})
  end
end
