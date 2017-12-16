use "collections"
use "debug"

class val Spin
  let _size: USize

  new val create(size: USize) =>
    _size = size

  fun apply(dl: DanceLine ref) =>
    dl.spin(_size)

class val Exchange
  let _a: USize
  let _b: USize

  new val create(a: USize, b: USize) =>
    _a = a
    _b = b

  fun apply(dl: DanceLine ref) ? =>
    dl.exchange(_a, _b)?

class val Partner
  let _a: U8
  let _b: U8

  new val create(a: U8, b: U8) =>
    _a = a
    _b = b

  fun apply(dl: DanceLine ref) ? =>
    dl.partner(_a, _b)?

type DanceLineCommand is (Spin | Exchange | Partner)

primitive CompileCommands
  fun apply(commands: Array[String] box): Array[DanceLineCommand] val ? =>
    let compiled_commands = recover trn Array[DanceLineCommand] end

    for command in commands.values() do
      match command(0)?
      | 's' =>
        let size = command.substring(1).usize()?
        compiled_commands.push(Spin(size))
      | 'x' =>
        let parts = command.substring(1).split("/")
        let a = parts(0)?.usize()?
        let b = parts(1)?.usize()?
        compiled_commands.push(Exchange(a, b))
      | 'p' =>
        let parts = command.substring(1).split("/")
        let a = parts(0)?.array()(0)?
        let b = parts(1)?.array()(0)?
        compiled_commands.push(Partner(a, b))
      end
    end

    consume compiled_commands

primitive ExecuteCommand
  fun apply(dance_line: DanceLine ref, command: String) ? =>
    match command(0)?
    | 's' =>
      let size = command.substring(1).usize()?
      dance_line.spin(size)
    | 'x' =>
      let parts = command.substring(1).split("/")
      let a = parts(0)?.usize()?
      let b = parts(1)?.usize()?
      dance_line.exchange(a, b)?
    | 'p' =>
      let parts = command.substring(1).split("/")
      let a = parts(0)?.array()(0)?
      let b = parts(1)?.array()(0)?
      dance_line.partner(a, b)?
    else
      error
    end

actor DanceLineActor
  let _dance_line: DanceLine

  new create(num_members: USize) =>
    _dance_line = DanceLine(num_members)

  be run_commands(commands: Array[DanceLineCommand] val,
    count: USize, out: OutStream)
  =>

    if (count % 10_000) == 0 then
      out.print("count = " + count.string())
    end

    if count > 0 then
      let steps = count.min(1000)
      for _ in Range(0, steps) do
        for c in commands.values() do
          try c(_dance_line)? end
        end
      end

      run_commands(commands, count - steps, out)
    else
      print(out)
    end

  be spin(x: USize) =>
    _dance_line.spin(x)

  be exchange(pos_a: USize, pos_b: USize) =>
    try _dance_line.exchange(pos_a, pos_b)? end

  be partner(a: U8, b: U8) =>
    try _dance_line.partner(a, b)? end

  be print(out: OutStream) =>
    out.print(_dance_line.string())

class DanceLine
  var _line: Array[U8]
  var _temp_line: Array[U8]

  new create(num_members: USize) =>
    _line = Array[U8](num_members)
    _temp_line = Array[U8](num_members)

    for i in Range(0, num_members) do
      _line.push('a' + i.u8())
    end

  fun ref spin(x: USize) =>
    _line.copy_to(_temp_line, 0, x,  _line.size() - x)
    _line.copy_to(_temp_line, _line.size() - x, 0,  x)
    let t = _line
    _line = _temp_line
    _temp_line = t

  fun ref exchange(pos_a: USize, pos_b: USize) ? =>
    _line.swap_elements(pos_a, pos_b)?

  fun ref partner(a: U8, b: U8) ? =>
    var pos_a: USize = _line.size()
    var pos_b: USize = _line.size()

    for (i, v) in _line.pairs() do
      if v == a then
        pos_a = i
      end
      if v == b then
        pos_b = i
      end
      if (pos_a < _line.size()) and (pos_b < _line.size()) then
        break
        _line.swap_elements(pos_a, pos_b)?
      end
    end

  fun array(): Array[U8] val =>
    let size = _line.size()
    let copy = recover trn Array[U8](size) end

    for v in _line.values() do
      copy.push(v)
    end

    consume copy

  fun string(): String =>
    let s = recover trn String end
    for c in _line.values() do
      s.push(c)
    end
    consume s
