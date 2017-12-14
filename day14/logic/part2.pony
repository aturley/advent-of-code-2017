use "collections"

primitive CountRegions
  fun apply(hashes: Array[Array[U64]]): U64 =>
    let grid = _Grid(hashes)

    let seen = Set[USize]
    let regions = Array[Set[USize]]

    for i in Range(0, grid.size()) do
      if not seen.contains(i) then
        let region = _find_region(grid, i)
        if region.size() > 0 then
          seen.union(region.values())
          regions.push(region)
        end
      end
    end

    regions.size().u64()

  fun _find_region(grid: _Grid, start: USize): Set[USize] =>
    let members: Set[USize] = Set[USize]
    let to_visit = Array[USize]
    to_visit.push(start)

    while to_visit.size() > 0 do
      try
        let visit = to_visit.pop()?
        let connections = grid.connections(visit)?
        for m in connections.values() do
          if not members.contains(m) then
            to_visit.push(m)
            members.set(m)
          end
        end
      end
    end

    members

class _Grid
  let _grid: Array[Array[Bool]] = Array[Array[Bool]]

  new create(hashes: Array[Array[U64]]) =>
    for hash in hashes.values() do
      let row = Array[Bool]
      _grid.push(row)

      for part in hash.values() do
        for i in Range(0, 8) do
          row.push((part and (1 << (7 - i)).u64()) != 0)
        end
      end
    end

  fun size(): USize =>
    try
      _grid.size() * _grid(0)?.size()
    else
      0
    end

  fun connections(pos: USize): Array[USize] val ? =>
    (let x, let y) = _pos_to_x_y(pos)

    let connections' = recover trn Array[USize] end

    if not _grid(x)?(y)? then
      return consume connections'
    else
      connections'.push(pos)
    end

    try
      if _grid(x + 1)?(y)? then
        connections'.push(_x_y_to_pos(x + 1, y))
      end
    end

    try
      if _grid(x - 1)?(y)? then
        connections'.push(_x_y_to_pos(x - 1, y))
      end
    end

    try
      if _grid(x)?(y + 1)? then
        connections'.push(_x_y_to_pos(x, y + 1))
      end
    end

    try
      if _grid(x)?(y - 1)? then
        connections'.push(_x_y_to_pos(x, y - 1))
      end
    end

    consume connections'

  fun _pos_to_x_y(pos: USize): (USize, USize) =>
    let x = pos / 128
    let y = pos % 128

    (x, y)

  fun _x_y_to_pos(x: USize, y: USize): USize =>
    (x * 128) + y
