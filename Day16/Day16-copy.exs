defmodule Node do
  defstruct [key: nil, neighbours: [], flow: 0, score: 0]

  def from_string(str) do
    [valve, flow, nbs] = str
    |> String.replace(["Valve ", " tunnels lead to valves ", " tunnel leads to valve "], "")
    |> String.replace(" has flow rate=", ";")
    |> String.split(";")
    %Node{key: valve, flow: String.to_integer(flow), neighbours: String.split(nbs, ", ")}
  end
end

defmodule Day16 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file("Input.md")
    #input = MyFunctions.read_file("Test.md")

    nodes = input
    |> Enum.map(fn x -> Node.from_string(x) end)
    |> IO.inspect

    #repeat(nodes, "AA", 100000)
    pathref = get_path_reference(nodes)
    pathref
  end

  def repeat(nodes, start, reps, best_path \\ [], best_score \\ 0) do
    {path, score} = random_traverse(nodes, [start])

    {best_path, best_score} = cond do
      score > best_score -> {path, score}
      true -> {best_path, best_score}
    end

    IO.inspect(reps)
    case reps do
      1 -> {best_path, best_score}
      _ -> repeat(nodes, start, reps - 1, best_path, best_score)
    end
  end

  def random_traverse(nodes, path, time_remaining \\ 30, total_score \\ 0) do
    nodes_with_flow = nodes
    |> Enum.filter(fn x -> x.flow > 0 end)

    cond do
      nodes_with_flow == [] || time_remaining == 0 ->
        {path, total_score}

      true ->
        next = Enum.random(nodes_with_flow)
        {new_nodes, new_path, new_time_remaining, score} = go_and_open_node(nodes, path, next, time_remaining)
        random_traverse(new_nodes, new_path, new_time_remaining, total_score + score)
    end
  end

  def go_and_open_node(nodes, path, next_node, time_remaining) do
    [current_key | tail] = path
    next_path = get_shortest_path(nodes, current_key, next_node.key)

    new_time_remaining = time_remaining - Enum.count(next_path) - 1
    new_path = next_path ++ tail
    score = new_time_remaining * next_node.flow
    new_nodes = zero_flow(nodes, next_node.key)

    {new_nodes, new_path, new_time_remaining, score}
  end

  def get_score(path, node, time_left) do
    Enum.max([time_left - Enum.count(path) - 1, 0]) * node.flow
  end

  def get_path_reference(nodes) do
    keys = Enum.map(nodes, fn x -> x.key end)
    key_pairs =
    for a <- keys, b <- keys, a != b, do: [a, b]

    key_pairs
    |> Enum.map(fn [a, b] -> {[a, b], get_shortest_path(nodes, a, b, 100)} end)
    |> Map.new
  end

  def get_shortest_path(nodes, start, finish, reps \\ 10, path \\ []) do
    new_path = get_path(nodes, finish, [start], [start])

    path = cond do
      path == [] -> new_path
      Enum.count(new_path) < Enum.count(path) -> new_path
      true -> path
    end

    cond do
      reps == 0 -> path
      true -> get_shortest_path(nodes, start, finish, reps - 1, path)
    end
  end

  def get_path(nodes, goal, path, tried) do
    [x | tail] = path
    nbs = Enum.filter(get_neighbours(nodes, x), fn x -> !Enum.member?(tried, x) end)

    cond do
      Enum.member?(nbs, goal) ->
        [goal | path]

      nbs == [] ->
        get_path(nodes, goal, tail, tried)

      true ->
        w = Enum.random(nbs)
        get_path(nodes, goal, [w | path], [w | tried])
    end
  end

  def zero_flow(nodes, key) do
    replace = fn x ->
      if x.key == key do
        %{x | flow: 0}
      else
        x
      end
    end

    Enum.map(nodes, fn x -> replace.(x) end)
  end

  # Try random traversal instead of this first -
  def get_best_next_node(nodes, position_key, time_left) do
    nodes_with_path = nodes
    |> Enum.filter(fn x -> x.flow > 0 end)
    |> Enum.map(fn x -> {x, get_shortest_path(nodes, position_key, x.key)} end)
    |> Enum.sort(fn {x1, path1}, {x2, path2} -> get_score(path1, x1, time_left) >= get_score(path2, x2, time_left) end)

    cond do
      nodes_with_path == [] -> nil
      true ->
        [pair | _] = nodes_with_path
        pair
    end
  end

  def get_neighbours(nodes, key), do: get_node(nodes, key).neighbours

  def get_node(nodes, key), do: Enum.find(nodes, fn x -> x.key == key end)

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
IO.inspect(Day16.run(), charlists: :as_lists)
