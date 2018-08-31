use "collections"

primitive GridFromStrings
  fun apply(strings: Array[String] box, grid_size: USize = 1001): Grid ? =>
    let start_size = strings.size()
    let grid = Grid(grid_size)
    let offset = (grid_size / 2) - (start_size / 2)
    for (i, s) in strings.pairs() do
      for (j, c) in s.array().pairs() do
        if c == '#' then
          grid.infect(((offset + i).isize(), (offset + j).isize()))?
        end
      end
    end

    grid

class Grid
  let _grid: Array[Array[U8]]
  let _size: USize

  new create(size': USize) =>
    _size = size'
    _grid = Array[Array[U8]](_size)
    for _ in Range(0, _size) do
      _grid.push(Array[U8].init('.', _size))
    end

  fun ref infect(pos: (ISize, ISize)) ? =>
    _grid(pos._1.usize())?(pos._2.usize())? = '#'

  fun ref clean(pos: (ISize, ISize)) ? =>
    _grid(pos._1.usize())?(pos._2.usize())? = '.'

  fun ref weaken(pos: (ISize, ISize)) ? =>
    _grid(pos._1.usize())?(pos._2.usize())? = 'W'

  fun ref flag(pos: (ISize, ISize)) ? =>
    _grid(pos._1.usize())?(pos._2.usize())? = 'F'

  fun get(pos: (ISize, ISize)): U8 ? =>
    _grid(pos._1.usize())?(pos._2.usize())?

  fun size(): USize =>
    _size

  fun string(): String =>
    let s = recover trn String end
    for r in _grid.values() do
      for c in r.values() do
        s.push(c)
      end
      s.push('\n')
    end
    consume s
