primitive _Right
primitive _Left
primitive _Up
primitive _Down

type Orientation is (_Right | _Left | _Up | _Down)

class Carrier
  var _pos: (ISize, ISize)
  var _orientation: Orientation
  var _infections: USize = 0

  new create(pos: (ISize, ISize)) =>
    _pos = pos
    _orientation = _Up

  fun ref left() =>
    _orientation = match _orientation
    | _Right => _Up
    | _Left => _Down
    | _Up => _Left
    | _Down => _Right
    end

  fun ref right() =>
    _orientation = match _orientation
    | _Right => _Down
    | _Left => _Up
    | _Up => _Right
    | _Down => _Left
    end

  fun ref flip() =>
    _orientation = match _orientation
    | _Right => _Left
    | _Left => _Right
    | _Up => _Down
    | _Down => _Up
    end

  fun ref move() =>
    (let dx: ISize, let dy: ISize) = match _orientation
    | _Right => ( 0,  1)
    | _Left =>  ( 0, -1)
    | _Up =>    (-1,  0)
    | _Down =>  ( 1,  0)
    end

    _pos = (_pos._1 + dx, _pos._2 + dy)

  fun ref burst(grid: Grid, evolved: Bool = false) ? =>
    if not evolved then
      match grid.get(_pos)?
      | '#' =>
        grid.clean(_pos)?
        right()
      | '.' =>
        grid.infect(_pos)?
        left()
        _infections = _infections + 1
      end
    else
      match grid.get(_pos)?
      | '#' =>
        grid.flag(_pos)?
        right()
      | '.' =>
        grid.weaken(_pos)?
        left()
      | 'F' =>
        grid.clean(_pos)?
        flip()
      | 'W' =>
        grid.infect(_pos)?
        _infections = _infections + 1
      else
        error
      end
    end
    move()

  fun infections(): USize =>
    _infections
