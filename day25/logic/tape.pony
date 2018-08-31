use "collections"

class Tape
  let _tape: Map[ISize, Mark]

  new create() =>
    _tape = Map[ISize, Mark]

  fun apply(pos: ISize): Mark =>
    _tape.get_or_else(pos, _Zero)

  fun ref zero(pos: ISize) =>
    _tape(pos) = _Zero

  fun ref one(pos: ISize) =>
    _tape(pos) = _One

  fun sum(): USize =>
    var s: USize = 0
    for v in _tape.values() do
      if v is _One then
        s = s + 1
      end
    end

    s
