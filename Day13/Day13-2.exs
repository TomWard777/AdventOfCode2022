defmodule Day13 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    Code.require_file("Input-code.exs")
    #Code.require_file("Test-code.exs")

    input = Input.get_input()

    test1 = [[2]]
    test2 = [[6]]

    list = [test1, test2] ++ input

    result = bubble_sort(list, Enum.count(list) + 1)
    ind1 = Enum.find_index(result, fn x -> x == test1 end) + 1
    ind2 = Enum.find_index(result, fn x -> x == test2 end) + 1

    print(ind1)
    print(ind2)
    ind1 * ind2
  end

  def bubble_sort(list, number_of_times) do
    newlist = bubble_sort_pass(list)
    cond do
      number_of_times == 1 -> newlist
      true -> bubble_sort(newlist, number_of_times - 1)
    end
  end

  def bubble_sort_pass(list, acc \\ [])

  def bubble_sort_pass([], acc), do: acc

  def bubble_sort_pass([x], acc), do: acc ++ [x]

  def bubble_sort_pass(list, acc) do
    [x | [y | tail]] = list
    case compare(x, y) do
      true -> bubble_sort_pass([y | tail], acc ++ [x])
      false -> bubble_sort_pass([x | tail], acc ++ [y])
    end
  end

  def compare(left, right) do
    #print(" ")
    #print(left)
    #print(right)
    cond do
      left == right -> nil

      is_number(left) && is_number(right) ->
        left < right

      is_list(left) && is_list(right) -> compare_lists(left, right)

      is_number(left) && is_list(right) -> compare_lists([left], right)

      is_list(left) && is_number(right) -> compare_lists(left, [right])
    end
  end

  def compare_lists([], []), do: nil

  def compare_lists(_, []), do: false

  def compare_lists([], _), do: true

  def compare_lists(left, right) do
    [x | left_tail] = left
    [y | right_tail] = right

    case compare(x, y) do
      true -> true
      false -> false
      nil -> compare(left_tail, right_tail)
    end
  end

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
Day13.print(Day13.run())
