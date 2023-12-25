defmodule Day13 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    #Code.require_file("Input-code.exs")
    Code.require_file("Test-code.exs")

    input = Input.get_input()
    |> MyFunctions.to_sublists(2)
    |> print
    |> Enum.map(fn [v,w] -> compare(v, w) end)
    |> Enum.with_index
    |> print()
    |> Enum.filter(fn {correct, _} -> correct end)
    |> Enum.map(fn {_, index} -> index + 1 end)
    |> Enum.sum
  end

  def compare(left, right) do
    print(" ")
    print(left)
    print(right)
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
IO.inspect(Day13.run(), charlists: :as_lists)
