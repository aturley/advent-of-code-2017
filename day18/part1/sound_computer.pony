// snd X plays a sound with a frequency equal to the value of X.

// set X Y sets register X to the value of Y.

// add X Y increases register X by the value of Y.

// mul X Y sets register X to the result of multiplying the value
// contained in register X by the value of Y.

// mod X Y sets register X to the remainder of dividing the value
// contained in register X by the value of Y (that is, it sets X to the
// result of X modulo Y).

// rcv X recovers the frequency of the last sound played, but only
// when the value of X is not zero. (If it is zero, the command does
// nothing.)

// jgz X Y jumps with an offset of the value of Y, but only if the
// value of X is greater than zero. (An offset of 2 skips the next
// instruction, an offset of -1 jumps to the previous instruction, and so
// on.)

class val _Register
  let _idx: USize

  new val create(idx: String)? =>
    _idx = (idx(0)? - 'a').usize()

  fun index(): USize =>
    _idx

class SoundComputer
  let _instructions: Array[Instruction] val
  let _registers: Array[I64]
  var _pc: USize
  var _last_sound: (I64 | None)

  new create(instructions: Array[Instruction] val) =>
    _instructions = instructions
    _registers = Array[I64].init(0, 26)
    _pc = 0
    _last_sound = None

  fun ref snd(arg: (_Register | I64)) ? =>
    let v = _value(arg)?
    _last_sound = v
    _pc = _pc + 1

  fun ref set(arg1: _Register, arg2: (_Register | I64)) ? =>
    _registers(arg1.index())? = _value(arg2)?
    _pc = _pc + 1

  fun ref add(arg1: _Register, arg2: (_Register | I64)) ? =>
    _registers(arg1.index())? = _registers(arg1.index())? + _value(arg2)?
    _pc = _pc + 1

  fun ref mul(arg1: _Register, arg2: (_Register | I64)) ? =>
    _registers(arg1.index())? = _registers(arg1.index())? * _value(arg2)?
    _pc = _pc + 1

  fun ref mod(arg1: _Register, arg2: (_Register | I64)) ? =>
    _registers(arg1.index())? = _registers(arg1.index())? % _value(arg2)?
    _pc = _pc + 1

  fun ref rcv(arg: (_Register | I64)): (I64 | None) ? =>
    let v = _value(arg)?
    _pc = _pc + 1
    if  v != 0 then
      return _last_sound
    end

  fun ref jgz(arg1: (_Register | I64), arg2: (_Register | I64)) ? =>
    let x = _value(arg1)?
    let y = _value(arg2)?

    _pc = (if x > 0 then (_pc.i64() + y).usize() else _pc + 1 end)

  fun ref next(): (I64 | None) ? =>
    let instruction = _instructions(_pc)?
    _run_instruction(instruction)?

  fun ref _run_instruction(instruction: Instruction): (I64 | None) ? =>
    instruction(this)?

  fun _value(v: (_Register | I64)): I64 ? =>
    match v
    | let r: _Register =>
      _registers(r.index())?
    | let i: I64 =>
      i
    end
