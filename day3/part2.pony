use "collections"

class Board
  let _board: Map[I64, Map[I64, U64]] = Map[I64, Map[I64, U64]]

  fun get(r: I64, c: I64): U64 =>
    try
      _board(r)?(c)?
    else
      0
    end

  fun ref put(r: I64, c: I64, v: U64) =>
    try
      _board.insert_if_absent(r, Map[I64, U64])?(c) = v
    end

  fun ref place(r: I64, c: I64): U64 =>
    var sum: U64 = 0
    let offsets: Array[(I64, I64)] = [( 1, -1); ( 1, 0); ( 1, 1); ( 0, -1); ( 0, 1); (-1, -1); (-1, 0); (-1, 1)]
    for offset in offsets.values() do
      sum = sum + get((r + offset._1), (c + offset._2))
    end
    put(r, c, sum)
    sum

primitive Part2
  fun apply(env: Env, input: U64) =>
    // difference from side, row offset, column offset
    let board = Board
    board.put(0, 0, 1)

    let directions: Array[(I64, I64, I64)] =
      [(-2, -1, 0); (-1, 0, -1); (-1, 1, 0); (0, 0, 1)]

    var cur_row: I64 = 0
    var cur_col: I64 = 1

    var side: I64 = 3

    while true do
      for (diff_side, row_offset, col_offset) in directions.values() do
        for i in Range[I64](0, side + diff_side) do
          let v = board.place(cur_row, cur_col)
          if v > input then
            env.out.print(v.string())
            return
          end
          cur_row = cur_row + row_offset
          cur_col = cur_col + col_offset
        end
      end
      side = side + 2
    end
