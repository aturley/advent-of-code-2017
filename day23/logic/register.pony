use "debug"

class val Register
  let _idx: USize

  new val create(letter: U8) =>
    _idx = (letter - 'a').usize()

  fun idx(): USize =>
    _idx

class Registers
  let _registers: Array[I64]
  var _pc: USize

  new create() =>
    _registers = Array[I64].init(0, 8)
    _pc = 0

  new from_start(start_registers: Array[I64] box) =>
    _registers = Array[I64].init(0, 8)

    for (i, v) in start_registers.slice(0,8).pairs() do
      try _registers(i)? = v end
    end

    _pc = try start_registers(8)?.usize() else 0 end

  fun ref set(arg1: Register, arg2: I64) ? =>
    _registers(arg1.idx())? = arg2

  fun get(arg1: Register): I64 ? =>
    _registers(arg1.idx())?

  fun ref set_pc(pc: USize) =>
    // if arg1.idx().u8() == ('h' - 'a') then
      let s = recover trn String end
      for (i, v) in _registers.pairs() do
        s.append(String.from_utf32(i.u32() + 'a') + "=" + v.string() + " ")
      end
      s.append("pc=" + _pc.string())
      Debug(consume s)
    // end
    _pc = pc

  fun ref inc_pc() =>
    _pc = _pc + 1

  fun get_pc(): USize =>
    _pc
