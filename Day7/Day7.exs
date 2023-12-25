defmodule Treenode do
  defstruct [key: nil, parent: nil, data: [], children: [], sizes: [], size: 0, total_size: 0]
end

defmodule Day7 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    #input = MyFunctions.read_file("Input.txt")

    nodes =
    read_file_to_single_string("Input.txt")
    #read_file_to_single_string("Test.txt")
    |> String.replace("$ cd", "END_DIRECTORY\r\n$ cd")
    |> String.split("\r\n")
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_while(
      %Treenode{},
      &chunk_fn/2,
      &after_fn/1)
    |> Enum.filter(fn x -> !disregard_node?(x) end)
    |> Enum.map(fn x -> get_size(x) end)

    nodes = Enum.map(nodes, fn x -> get_parent(nodes, x) end)

    IO.inspect(nodes, label: "With parents")
keys = Enum.map(nodes, fn x -> x.key end)
IO.inspect(Enum.count(keys))
IO.inspect(Enum.count(MyFunctions.distinct(keys)))
IO.inspect(Enum.sort(keys))
IO.inspect(Enum.slice(Enum.sort(keys),40..80))
IO.inspect("FUCK")
    # TODO TW - the error is probably in somewhere here.
    excludedkeys = Enum.filter(nodes, fn x -> x.size > 100000 end)
    |> Enum.map(fn x -> x.key end)

    IO.inspect(Enum.count(excludedkeys))
    IO.inspect(Enum.count(MyFunctions.distinct(excludedkeys)))

    excludedkeys = get_ancestors(nodes, excludedkeys)

    IO.inspect(Enum.count(excludedkeys))

    nodes
    |> Enum.filter(fn x -> !Enum.member?(excludedkeys, x.key) end)
    |> Enum.map(fn x -> get_total_size(nodes, x) end)
    |> IO.inspect
    |> Enum.filter(fn x -> x.total_size <= 100000 end)
    |> Enum.map(fn x -> x.total_size end)
    |> Enum.sum
  end

  def chunk_fn(elt, acc) do
    cond do
      String.contains?(elt, "$ ls") -> {:cont, acc}

      String.contains?(elt, "$ cd") ->
        "$ cd " <> dir = elt; {:cont, %{acc | key: dir}}

        String.contains?(elt, "END_DIRECTORY") -> {:cont, acc, %Treenode{}}

      String.contains?(elt, "dir ") ->
        "dir " <> dir = elt; {:cont, %{acc | children: [dir | acc.children]}}

      true ->
        [size | _] = String.split(elt)
        {:cont, %{ acc | data: [elt | acc.data], sizes: [String.to_integer(size) | acc.sizes]} }
    end
  end

  def after_fn(acc) do
    {:cont, acc, %Treenode{}}
  end

  def disregard_node?(%Treenode{} = node) do
    Enum.count(node.data) == 0 && Enum.count(node.children) == 0 && (node.key == nil || node.key == "..")
  end

  def get_ancestors(nodes, keys) do
    parents = Enum.filter(nodes, fn x -> Enum.member?(keys, x.key) end)
    |> Enum.map(fn x -> x.parent end)
    |> Enum.filter(fn x -> x != nil end)

    newkeys = MyFunctions.distinct(parents ++ keys)

    cond do
      Enum.count(newkeys) == Enum.count(keys) -> newkeys
      true -> get_ancestors(nodes, newkeys)
    end
  end

  def get_parent(nodes, %Treenode{} = node) do
    parent = Enum.find(nodes, fn x -> Enum.member?(x.children, node.key) end)
    case parent do
      nil -> node
      _ -> %{node | parent: parent.key}
    end
  end

  def get_size(%Treenode{} = node) do
    %{node | size: Enum.sum(node.sizes)}
  end

  def get_total_size(nodes, %Treenode{} = node) do
    total = node.size + get_subdirs_size(nodes, node.children)
    %{node | total_size: total}
  end

  def get_subdirs_size(_, []), do: 0

  def get_subdirs_size(nodes, keys) do
    [k | rest] = keys
    node = Enum.find(nodes, fn x -> x.key == k end)

    cond do
      rest == [] -> node.size + get_subdirs_size(nodes, node.children)
      true -> node.size + get_subdirs_size(nodes, node.children) + get_subdirs_size(nodes, rest)
    end
  end

  def read_file_to_single_string(filename) do
    case File.read(filename) do
        {:ok, body} -> body
        {:error, message} -> IO.inspect(message, label: "Error reading file:")
    end
  end
end

test = Day7.run()
IO.inspect(test, label: "Result")
