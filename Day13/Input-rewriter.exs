defmodule Rewriter do
  def run() do
    Code.require_file("MyFunctions.exs", "../")

    File.stream!("Input-code.exs")
    |> Enum.filter(fn x -> x != "," end)
    |> IO.inspect()
    |> File.write("output.txt")
  end

  def read_file(filename) do
    case File.read(filename) do
        {:ok, body} -> String.split(body, "\r\n")
        {:error, message} -> IO.inspect(message, label: "Error reading file:")
    end
  end
end

IO.inspect(Rewriter.run())
