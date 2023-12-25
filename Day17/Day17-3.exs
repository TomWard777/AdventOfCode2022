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
  #@number 2022
  @number 1000000000000

  def run() do
    Code.require_file("MyFunctions.exs", "../")
    #input = MyFunctions.read_file_to_single_string("Input.md")
    input = MyFunctions.read_file_to_single_string("Test.md")
    # 40 test moves, 10091 real ones

    moves = input
    |> String.to_charlist()
    |> IO.inspect

    first_tetromino = Tetromino.new(:minus, 3, 4)
    {blocks, height} = move_and_drop(MapSet.new(), first_tetromino, moves)
    #IO.inspect(draw(blocks))
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
      MapSet.member?(blocks, p) -> "#"
      true -> "."
    end
  end

  def move_and_drop(blocks, tetromino, moves, index \\ 0, acc \\ 0) do
    {direction, new_index} = get_move(moves, index)
    tetromino = move_once(blocks, direction, tetromino)
    dropped = drop_once(blocks, tetromino)

    cond do
      acc == @number ->
        {blocks, get_height(blocks)}

      dropped.points == tetromino.points ->
        # Has come to rest
        blocks = MapSet.union(blocks, MapSet.new(tetromino.points))
        new_tetromino = get_next_tetromino(blocks, tetromino.shape)

        blocks = cond do
          rem(acc + 1, 100) == 0 -> blocks
            #filter_block_set(blocks)

            true -> blocks
         end

        #if rem(acc + 1, 5) == 0 do IO.inspect({acc+1, new_index}) end
         if contains_line(blocks) do IO.inspect({acc+1, new_index}, label: "Found line") end
         if new_index == 0 do IO.inspect(acc) end
        #if rem(@number - acc, 10000) == 0 do IO.inspect(@number - acc) end
        #IO.inspect(get_height(blocks))

        move_and_drop(blocks, new_tetromino, moves, new_index, acc + 1)

      true ->
        move_and_drop(blocks, dropped, moves, new_index, acc)
    end
  end

  def contains_line(blocks) do
    list = MapSet.to_list(blocks)
    test = Enum.map(list, fn [_, y] -> y end)
    |> Enum.map(fn y -> contains_line_at_y(blocks, y) end)
    |> Enum.filter(fn check -> check end)

    test != []
  end

  def contains_line_at_y(blocks, y) do
    s = MapSet.new([[1,y], [2,y], [3,y], [4,y], [5,y], [6,y], [7,y]])
    MapSet.subset?(s, blocks)
  end

  def filter_block_set(blocks) do
    block_list = MapSet.to_list(blocks)
    y_cutoff = get_lowest_y(block_list)
    Enum.filter(block_list, fn [_, y] -> y >= y_cutoff end)
    |> MapSet.new()
  end

  def get_lowest_y(blocks) do
    [1, 2, 3, 4, 5, 6, 7]
    |> Enum.map(fn x -> get_height_for_x(blocks, x) end)
    |> Enum.min
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

  def get_height_for_x(blocks, x0) do
    yvalues = blocks
    |> Enum.filter(fn [x, _] -> x == x0 end)
    |> Enum.map(fn [x, y] -> y end)
    cond do
      yvalues == [] -> -1
      true -> Enum.max(yvalues)
    end
  end

  def get_height(blocks) do
    blocks
    |> MapSet.to_list()
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

    cond do
      new_left_edge < 1 -> tetromino
      new_left_edge + tetromino.width - 1 > 7 -> tetromino
      !MapSet.disjoint?(MapSet.new(new_points), blocks) -> tetromino
      true -> %{tetromino | points: new_points, left_edge: new_left_edge}
    end
  end

  def drop_once(blocks, %Tetromino{} = tetromino) do
    new_bottom_edge = tetromino.bottom_edge - 1
    new_points = Enum.map(tetromino.points, fn [x, y] -> [x, y-1] end)

    cond do
      new_bottom_edge == 0 -> tetromino
      !MapSet.disjoint?(MapSet.new(new_points), blocks) -> tetromino
      true -> %{tetromino | points: new_points, bottom_edge: new_bottom_edge}
    end
  end

  def print(x), do: IO.inspect(x, charlists: :as_lists)
end

IO.puts("Result:")
IO.inspect(Day16.run(), charlists: :as_lists)
