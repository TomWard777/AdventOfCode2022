defmodule Day7 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    #input = read_file("Input.txt")

    read_file("Test.txt")
    |> Enum.map(&String.trim/1)
    |> IO.inspect
    |> Enum.chunk_while(
      [],
      &chunk_fn/2,
      &after_fn/1)
    |> Enum.filter(fn x -> x != [] end)
    |> IO.inspect(label: "Chunk results")
  end

  def chunk_fn(elt, acc) do
    cond do
      String.contains?(elt, "$ ls") -> {:cont, acc}
      String.contains?(elt, "$ cd") -> {:cont, Enum.reverse(acc), []}
      true -> {:cont, [elt | acc]}
    end
  end

  def after_fn(acc) do
    case acc do
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), []}
    end
  end

  def read_file(filename) do
      case File.read(filename) do
          {:ok, body} -> String.split(body, "\r\n")
          {:error, message} -> IO.inspect(message, label: "Error reading file:")
      end
  end
end

test = Day7.run()
IO.inspect(test, label: "Result")
