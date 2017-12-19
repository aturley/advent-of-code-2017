use c = "collections"

primitive MapFromString
  fun apply(map_string: String): Map ? =>
    let map = recover trn Map end

    for l in map_string.split("\n").values() do
      let map_row = recover trn Array[MapElement] end
      for i in l.values() do
        let element = match i
        | '+' => Turn
        | '-' => Horz
        | '|' => Vert
        | ' ' => Empty
        | let letter: U8 if (letter >= 'A') and (letter <= 'Z') =>
          Letter(letter)
        else
          error
        end
        map_row.push(element)
      end
      map.add_row(consume map_row)
    end
    consume map

primitive Turn
  fun string(): String =>
    "+"

primitive Horz
  fun string(): String =>
    "-"

primitive Vert
  fun string(): String =>
    "|"

primitive Empty
  fun string(): String =>
    "%"

primitive Border
  fun string(): String =>
    "#"

class val Letter
  let letter: U8

  new val create(l: U8) =>
    letter = l

  fun string(): String =>
    let s = recover trn String end
    s.push(letter)
    consume s

type MapElement is (Turn | Horz | Vert | Empty | Border | Letter)

class val Map
  let _rows: Array[Array[MapElement] val]

  new create() =>
    _rows = Array[Array[MapElement] val]

  fun ref add_row(r: Array[MapElement] val) =>
    _rows.push(r)

  fun apply(row: ISize, col: ISize): MapElement =>
    if (row < 0) or (col < 0) then
      return Border
    end

    try
      _rows(row.usize())?(col.usize())?
    else
      Border
    end

  fun trace(): ((ISize, ISize), Array[String] val, USize) ? =>
    var pos = _start()?
    var dir: (ISize, ISize) = (1, 0)
    var steps: USize = 1

    let letters = recover trn Array[String] end

    while apply(pos._1, pos._2) isnt Border do
      let next_pos = ((pos._1 + dir._1), (pos._2 + dir._2))

      if apply(next_pos._1, next_pos._2) is Empty then
        return (pos, consume letters, steps)
      end

      steps = steps + 1

      match apply(next_pos._1, next_pos._2)
      | let letter: Letter =>
        letters.push(letter.string())
      | Turn =>
        let dirs = match dir
        | (0, _) =>
          [as (ISize, ISize): (-1, 0); (1, 0)]
        |(_, 0) =>
          [as (ISize, ISize): (0, -1); (0, 1)]
        else
          error
        end

        for d in dirs.values() do
          if _check_dir(next_pos, d)? then
            dir = d
            break
          end
        end
      end

      pos = next_pos
    end
    (pos, consume letters, steps)

  fun string(): String =>
    let s = recover trn String end
    for r in _rows.values() do
      for e in r.values() do
        s.append(e.string())
      end
      s.append("\n")
    end

    consume s

  fun _start(): (ISize, ISize) ? =>
    for i in c.Range(0, _rows(0)?.size()) do
      if apply(0, i.isize()) is Vert then
        return(0, i.isize())
      end
    end

    error

  fun _check_dir(pos: (ISize, ISize), dir: (ISize, ISize)): Bool ? =>
    let target_connector = match dir
    | (_, 0) => Vert
    | (0, _) => Horz
    else
      error
    end

    var test_pos = (pos._1 + dir._1, pos._2 + dir._2)
    var valid_dir = false

    while true do
      match apply(test_pos._1, test_pos._2)
      | let conn: (Horz | Vert) if conn is target_connector =>
        return true
      | Turn =>
        return false
      | Border =>
        return false
      | Empty =>
        return false
      | let l: Letter =>
        return true
      end
      test_pos = (test_pos._1 + dir._1, test_pos._2 + dir._2)
    end

    false
