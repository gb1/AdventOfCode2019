defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "parse the map" do
    map = """
    .#..#
    .....
    #####
    ....#
    ...##
    """

    map = Day10.parse_map(map)

    assert map[{1, 0}] == "#"
    assert map[{0, 2}] == "#"
    assert map[{4, 4}] == "#"
    assert map[{0, 4}] == "."
  end

  test "other asteroids in sight" do
    map = """
    .#..#
    .....
    #####
    ....#
    ...##
    """

    map = Day10.parse_map(map)

    assert Day10.other_asteroids_in_sight(map, {3, 4}) == 8
    assert Day10.other_asteroids_in_sight(map, {0, 2}) == 6
    assert Day10.other_asteroids_in_sight(map, {2, 2}) == 7
  end

  test "a bigger test" do
    map =
      """
      .#..##.###...#######
      ##.############..##.
      .#.######.########.#
      .###.#######.####.#.
      #####.##.#.##.###.##
      ..#####..#.#########
      ####################
      #.####....###.#.#.##
      ##.#################
      #####.##.###..####..
      ..######..##.#######
      ####.##.####...##..#
      .#####..#.######.###
      ##...#.##########...
      #.##########.#######
      .####.#.###.###.#.##
      ....##.##.###..#####
      .#.#.###########.###
      #.#.#.#####.####.###
      ###.##.####.##.#..##
      """
      |> Day10.parse_map()

    assert Day10.other_asteroids_in_sight(map, {11, 13}) == 210
  end

  test "slope between points" do
    assert Day10.slope({0, 0}, {1, 1}) == 1
    assert Day10.slope({1, 1}, {2, 3}) == 2
    assert Day10.slope({2, 3}, {1, 1}) == 2
  end

  test "get neighbours" do
    map = """
    .#..#
    .....
    #####
    ....#
    ...##
    """

    map = Day10.parse_map(map)

    n = Day10.neighbours(map, {0, 0})

    assert n == %{{1, 0} => "#", {0, 1} => ".", {1, 1} => "."}
  end
end
