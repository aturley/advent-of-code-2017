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

  let _memory: Map[String, USize]

  new create(num_members: USize) =>
    _dance_line = DanceLine(num_members)
    _memory = Map[String, USize]

  be run_commands(commands: Array[DanceLineCommand] val,
    count: USize, out: OutStream, memo: Bool)
  =>
    if count > 0 then
      _memory(_dance_line.string()) = count
      for c in commands.values() do
        try c(_dance_line)? end
      end
      if memo then
        if _memory.contains(_dance_line.string()) then
          let start_of_last_cycle = _memory.get_or_else(_dance_line.string(), 0)
          let cycle_length = (start_of_last_cycle - count) + 1
          let cycles_remaining = count / cycle_length
          let skip_to_count = count - (cycles_remaining * cycle_length)
          run_commands(commands, skip_to_count - 1, out, false)
        else
          run_commands(commands, count - 1, out, memo)
        end
      else
        run_commands(commands, count - 1, out, memo)
      end
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
  var _start: USize
  let _num_members: USize
  let _lookup_table: Array[USize]

  new create(num_members: USize) =>
    _line = Array[U8](num_members)
    _lookup_table = Array[USize](num_members)
    _temp_line = Array[U8](num_members)
    _start = 0
    _num_members = num_members

    for i in Range(0, num_members) do
      _line.push('a' + i.u8())
      _lookup_table.push(i)
    end

  fun ref spin(x: USize) =>
    _start = ((_num_members - x) + _start) % _num_members

  fun ref exchange(pos_a: USize, pos_b: USize) ? =>
    _line.swap_elements(_offset(pos_a), _offset(pos_b))?
    let letter_a_idx = _line(_offset(pos_a))? - 'a'
    let letter_b_idx = _line(_offset(pos_b))? - 'a'
    _lookup_table.swap_elements(letter_a_idx.usize(), letter_b_idx.usize())?

  fun ref partner(a: U8, b: U8) ? =>
    var lookup_pos_a = (a - 'a').usize()
    var lookup_pos_b = (b - 'a').usize()
    var pos_a = _lookup_table(lookup_pos_a)?
    var pos_b = _lookup_table(lookup_pos_b)?
    _line.swap_elements(pos_a, pos_b)?
    _lookup_table.swap_elements(lookup_pos_a, lookup_pos_b)?

  fun array(): Array[U8] val =>
    let size = _line.size()
    let copy = recover trn Array[U8](size) end

    for i in Range(0, _num_members) do
      try copy.push(_line(_offset(i))?) end
    end

    consume copy

  fun string(): String =>
    let d = recover trn String end
    d.append(String.from_array(array()) + "\n")
    let l = Array[String](_num_members)
    for i in Range(0, _num_members) do
      try l.push(_lookup_table(i)?.string()) end
    end
    d.append(" ".join(l.values()))
    // Debug((consume d) + " start = " + _start.string())
    String.from_array(array())

  fun _offset(p: USize): USize =>
    (p + _start) % _num_members
