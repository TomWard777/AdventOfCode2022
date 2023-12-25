defmodule Tetromino do
  defstruct [shape: nil, left_edge: [0, 0], bottom_edge: [0, 0], points: [], width: 0]

  def new(shape, x, y) do
    tetromino = %Tetromino{shape: shape, left_edge: x, bottom_edge: y}
    width =
      case shape do
        :minus -> 4
        :plus -> 3
        :backwards_l -> 3
        :vertical_line -> 1
        :square -> 2
      end

    points =
      case shape do
        :minus -> [[x, y], [x+1, y], [x+2, y], [x+3, y]]
        :plus -> [[x+1, y], [x, y+1], [x+1, y+1], [x+2, y+1], [x+1, y+2]]
        :backwards_l -> [[x, y], [x+1, y], [x+2, y], [x+2, y+1], [x+2, y+2]]
        :vertical_line -> [[x, y], [x, y+1], [x, y+2], [x, y+3]]
        :square -> [[x, y], [x+1, y], [x, y+1], [x+1, y+1]]
      end
    %{tetromino | points: points, width: width}
  end
end

defmodule Day16 do
  def run() do
    Code.require_file("MyFunctions.exs", "../")
    input = MyFunctions.read_file_to_single_string("Input.md")
    #input = MyFunctions.read_file_to_single_string("Test.md")

    moves = input
    |> String.to_charlist()
    |> IO.inspect

    first_tetromino = Tetromino.new(:minus, 3, 4)
    {blocks, height} = move_and_drop([], first_tetromino, moves)
    IO.inspect(draw(blocks))
    height
  end

  def draw(blocks) do
    h = get_height(blocks)
    pts = for y <- h..1, x <- 1..7, do: [x, y]
    Enum.map(pts, &(draw_point(blocks, &1)))
    |> MyFunctions.to_sublists(7)
  end

  def draw_point(blocks, p) do
    cond do
      Enum.member?(blocks, p) -> "#"
      true -> "."
    end
  end

  def move_and_drop(blocks, tetromino, moves, index \\ 0, acc \\ 0) do
    {direction, new_index} = get_move(moves, index)
    tetromino = move_once(blocks, direction, tetromino)
    dropped = drop_once(blocks, tetromino)

    cond do
      acc == 2022 ->
        {blocks, get_height(blocks)}

      dropped.points == tetromino.points ->
        # Has come to rest
        blocks = tetromino.points ++ blocks
        new_tetromino = get_next_tetromino(blocks, tetromino.shape)

        IO.inspect(acc)
        #IO.inspect(get_height(blocks))

        move_and_drop(blocks, new_tetromino, moves, new_index, acc + 1)

      true ->
        move_and_drop(blocks, dropped, moves, new_index, acc)
    end
  end

  def get_move(moves, index) do
    direction = Enum.at(moves, index)
    index = index + 1
    cond do
      index > Enum.count(moves) - 1 -> {direction, 0}
      true -> {direction, index}
    end
  end

  def get_next_tetromino(blocks, previous_shape) do
    shape = get_next_shape(previous_shape)
    blocks_height = get_height(blocks)
    Tetromino.new(shape, 3, blocks_height + 4)
  end

  def get_height(blocks) do
    blocks
    |> Enum.map(fn [x, y] -> y end)
    |> Enum.max
  end

  def get_next_shape(shape) do
    case shape do
      :minus -> :plus
      :plus -> :backwards_l
      :backwards_l -> :vertical_line
      :vertical_line -> :square
      :square -> :minus
    end
  end

  def move_once(blocks, direction, %Tetromino{} = tetromino) do
    {new_points, new_left_edge} =
      case direction do
        60 ->
          {Enum.map(tetromino.points, fn [x, y] -> [x-1, y] end), tetromino.left_edge - 1}
        62 ->
          {Enum.map(tetromino.points, fn [x, y] -> [x+1, y] end), tetromino.left_edge + 1}
      end

    overlap = Enum.filter(new_points, fn x -> Enum.member?(blocks, x) end)

    cond do
      new_left_edge < 1 -> tetromino
      new_left_edge + tetromino.width - 1 > 7 -> tetromino
      overlap != [] -> tetromino
      true -> %{tetromino | points: new_points, left_edge: new_left_edge}
    end
  end

  def drop_once(blocks, %Tetromino{} = tetromino) do
    new_bottom_edge = tetromino.bottom_edge - 1
    new_points = Enum.map(tetromino.points, fn [x, y] -> [x, y-1] end)
    overlap = Enum.filter(new_points, fn x -> Enum.member?(blocks, x) end)

    cond do
      new_bottom_edge == 0 -> tetromino
      overlap != [] -> tetromino
      true -> %{tetromino | points: new_points, bottom_edge: new_bottom_edge}
    end
  end

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
IO.inspect(Day16.run(), charlists: :as_lists)
