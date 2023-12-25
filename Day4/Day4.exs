defmodule RangePair do
  defstruct [pair1: %{}, pair2: %{}]

  def new(a1, b1, a2, b2) do
    %RangePair{pair1: %{1 => a1, 2 => b1}, pair2: %{1 => a2, 2 => b2}}
  end

  def from_string(str) do
    [s1, s2] = String.split(str, ",")

    [a1, b1] =
      String.split(s1, "-")
      |> Enum.map(fn s -> String.to_integer(s) end)

    [a2, b2] =
      String.split(s2, "-")
      |> Enum.map(fn s -> String.to_integer(s) end)

      new(a1,b1,a2,b2)
  end
end

defmodule Day4 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = read_file("Input.txt")
    #input = read_file("Test.txt")

    input
    |> Enum.map(fn item -> RangePair.from_string(item) end)
    |> Enum.filter(fn pair -> overlaps?(pair) end)
    |> Enum.count()
  end

  def overlaps?(%RangePair{} = rangepair) do
    p1 = rangepair.pair1
    p2 = rangepair.pair2

    [p1,p2] = cond do
      p1[1] > p2[1] -> [p2,p1]
      true -> [p1,p2]
    end

    cond do
      p1[2] >= p2[1] -> true
      true -> false
    end
  end

  def contains?(%RangePair{} = rangepair) do
    p1 = rangepair.pair1
    p2 = rangepair.pair2

    cond do
      p1[1] <= p2[1] && p2[2] <= p1[2] -> true
      p2[1] <= p1[1] && p1[2] <= p2[2] -> true
      true -> false
    end
  end

  def read_file(filename) do
      case File.read(filename) do
          {:ok, body} -> String.split(body, "\r\n")
          {:error, message} -> IO.inspect(message, label: "Error reading file:")
      end
  end
end

test = Day4.run()
IO.inspect(test, label: "Result")
