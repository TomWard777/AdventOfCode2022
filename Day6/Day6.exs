defmodule Day6 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = read_file("Input.txt")
    #input = read_file("Test.txt")

    input
    |> Enum.at(0)
    |> String.to_charlist()
    |> IO.inspect
    |> first_distinct(14)
  end

  def first_distinct(list, packet_length, ind \\ 0) do
    test = list
    |> Enum.slice(ind-packet_length..ind-1)
    |> MyFunctions.distinct
    |> Enum.count

    cond do
        test < packet_length -> first_distinct(list, packet_length, ind + 1)
        test == packet_length -> ind
        true -> raise("Error!")
    end
  end

  def read_file(filename) do
      case File.read(filename) do
          {:ok, body} -> String.split(body, "\r\n")
          {:error, message} -> IO.inspect(message, label: "Error reading file:")
      end
  end
end

test = Day6.run()
IO.inspect(test, label: "Result")
