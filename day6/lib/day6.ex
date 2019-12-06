defmodule Day6 do
  @root "COM"

  def part1 do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ")"))
    |> build_graph()
    |> dfs([@root], [@root], [])
    |> List.flatten()
    |> Enum.reject(&(&1 == @root))
    |> length()
  end

  ## find the point in the two paths where they diverge, result is length of the remaing two paths
  def part2 do
    paths =
      File.read!("input")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ")"))
      |> build_graph()
      |> dfs([@root], [@root], [])

    santa_path = paths |> Enum.filter(&Enum.member?(&1, "SAN")) |> List.first() |> Enum.reverse()
    my_path = paths |> Enum.filter(&Enum.member?(&1, "YOU")) |> List.first() |> Enum.reverse()

    zipped_paths = Enum.zip(my_path, santa_path)

    {diverge_me, diverge_santa} =
      zipped_paths
      |> Enum.filter(fn {x, y} ->
        x != y
      end)
      |> List.first()

    length(Enum.take_while(Enum.reverse(santa_path), &(&1 != diverge_santa))) + length(Enum.take_while(Enum.reverse(my_path), &(&1 != diverge_me)))
  end

  @doc """
  Build an adjacency map for the graph

  iex>Day6.build_graph [["COM","B"],["B","C"],["C","D"],["D","E"],["E","F"],["B","G"],["G","H"],["D","I"],["E","J"],["J","K"],["K","L"]]
  %{ "B" => ["G", "C"],
  "C" => ["D"],
  "COM" => ["B"],
  "D" => ["I", "E"],
  "E" => ["J", "F"],
  "G" => ["H"],
  "J" => ["K"],
  "K" => ["L"] }
  """
  def build_graph(map) do
    map
    |> Enum.reduce(%{}, fn [x, y], acc ->
      Map.update(acc, x, [y], &[y | &1])
    end)
  end

  # Do a depth first search and return all full paths
  def dfs(_map, [], _visited, paths), do: paths

  def dfs(map, [current | stack], visited, paths) do
    case map[current] do
      nil ->
        dfs(map, stack, visited, List.insert_at(paths, 1, [current | stack]))

      _ ->
        nodes = map[current] |> Enum.reject(&Enum.member?(visited, &1))

        case nodes do
          [] ->
            dfs(map, stack, visited, List.insert_at(paths, 1, [current | stack]))

          _ ->
            dfs(map, [List.first(nodes), current | stack], [List.first(nodes) | visited], paths)
        end
    end
  end
end
