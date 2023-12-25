defmodule MyFunctions do
  def read_file(filename) do
    case File.read(filename) do
        {:ok, body} -> String.split(body, "\r\n")
        {:error, message} -> IO.inspect(message, label: "Error reading file:")
    end
  end

  def to_sublists([], _), do: []

  def to_sublists(list, sublist_size) do
    len = length(list)
    first = Enum.slice(list, 0..sublist_size-1)
    rest = Enum.slice(list, sublist_size..len-1)
    [first | to_sublists(rest, sublist_size)]
  end

  def intersect_all([]), do: []

  def intersect_all([list]), do: list

  def intersect_all(list_of_lists) do
    [head | tail] = list_of_lists
    intersection(head, intersect_all(tail))
  end

  def intersection(list1, list2) do
    intersection_multiple(distinct(list1), distinct(list2))
  end

  def distinct([]), do: []

  def distinct([head | tail]) do
    case Enum.member?(tail, head) do
      false -> [head | distinct(tail)]
      true -> distinct(tail)
    end
  end

  defp intersection_multiple(_, []), do: []

  defp intersection_multiple([], _), do: []

  defp intersection_multiple([head | tail], list2) do
    case Enum.member?(list2, head) do
      true -> [head | intersection(tail, list2)]
      false -> intersection(tail, list2)
    end
  end
end
