use "collections"

primitive GridFromStrings
  fun apply(strings: Array[Array[String] box] box): Grid ? =>
    let side: USize = match strings(0)?(0)?.size()
    | 5 =>
      2
    | 11 =>
      3
    else
      error
    end

    let grid = Grid(strings.size() * side)

    for (i, ss) in strings.pairs() do
      for (j, s) in ss.pairs() do
        for (k, g) in s.split("/").pairs() do
          for (l, v) in g.array().pairs() do
            grid.put((i * side) + k, (j * side) + l, v)?
          end
        end
      end
    end

    grid

class Grid
  let _grid: Array[Array[U8]]
  let _size: USize

  new create(size: USize) =>
    _grid = Array[Array[U8]]
    for i in Range(0, size) do
      _grid.push(Array[U8].init(0, size))
    end
    _size = size

  fun ref put(x: USize, y: USize, value: U8) ? =>
    _grid(x)?(y)? = value

  fun string(): String =>
    let ss = recover trn Array[String] end
    for a in _grid.values() do
      let s = recover String end
      for v in a.values() do
        if (v == '.') or (v == '#') then
          s.push(v)
        else
          s.push('x')
        end
      end
      ss.push(consume s)
    end
    "\n".join((consume ss).values())

  fun squares(): Array[Array[String] val] val ? =>
    let part_size: USize = if (_size % 2) == 0 then
      2
    else
      3
    end

    let parts = recover trn Array[Array[String] val] end
    for i in Range(0, _size, part_size) do
      let part = recover trn Array[String] end
      for j in Range(0, _size, part_size) do
        let ss = recover trn Array[String] end
        for i2 in Range(0, part_size) do
          let s = recover trn String end
          for j2 in Range(0, part_size) do
            s.push(_grid(i + i2)?(j + j2)?)
          end
          ss.push(consume s)
        end
        part.push("/".join((consume ss).values()))
      end
      parts.push(consume part)
    end

    consume parts

  fun transform(pattern_book: PatternBook): Grid ? =>
    (let new_size, let skip_size: USize) = if (_size % 2) == 0 then
      ((_size / 2) * 3, 3)
    else
      ((_size / 3) * 4, 4)
    end

    let new_grid = Grid(new_size)

    let grid_of_squares = squares()?

    for (i, row_of_squares) in grid_of_squares.pairs() do
      for (j, square) in row_of_squares.pairs() do
        for (i2, line) in pattern_book.lookup(square)?.split("/").pairs() do
          for (j2, v) in line.array().pairs() do
            new_grid.put((i * skip_size)+ i2, (j * skip_size) + j2, v)?
          end
        end
      end
    end

    new_grid

  fun count_on(): USize =>
    var total: USize = 0
    for x in _grid.values() do
      for v in x.values() do
        if v == '#' then
          total = total + 1
        end
      end
    end
    total
