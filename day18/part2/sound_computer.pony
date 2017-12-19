class val _Register
  let _idx: USize

  new val create(idx: String)? =>
    _idx = (idx(0)? - 'a').usize()

  fun index(): USize =>
    _idx

primitive Stopped

class SoundComputer
  let _instructions: Array[Instruction] val
  let _registers: Array[I64]
  var _pc: USize
  let _queue: Array[I64]
  var _partner: (SoundComputer | None)
  var _sends: U64
  var _id: I64

  new create(id: I64, instructions: Array[Instruction] val) =>
    _instructions = instructions
    _registers = Array[I64].init(0, 26)
    try _registers(_Register("p")?.index())? = id end
    _pc = 0
    _queue = Array[I64]
    _partner = None
    _sends = 0
    _id = id

  fun ref partner(p: SoundComputer) =>
    _partner = p

  fun sends(): U64 =>
    _sends

  fun ref snd(arg: (_Register | I64)) ? =>
    _pc = _pc + 1

    match _partner
    | let p: SoundComputer =>
      p.enqueue(_value(arg)?)
      _sends = _sends + 1
    end

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

  fun ref rcv(arg: _Register): (Stopped | None) ? =>
    if _queue.size() == 0 then
      return Stopped
    end

    let v = _queue.shift()?
    _registers(arg.index())? = v
    _pc = _pc + 1
    None

  fun ref jgz(arg1: (_Register | I64), arg2: (_Register | I64)) ? =>
    let x = _value(arg1)?
    let y = _value(arg2)?

    _pc = (if x > 0 then (_pc.i64() + y).usize() else _pc + 1 end)

  fun ref enqueue(v: I64) =>
    _queue.push(v)

  fun ref next(): (Stopped | None) ? =>
    let instruction = _instructions(_pc)?
    _run_instruction(instruction)?

  fun ref _run_instruction(instruction: Instruction): (Stopped | None) ? =>
    instruction(this)?

  fun _value(v: (_Register | I64)): I64 ? =>
    match v
    | let r: _Register =>
      _registers(r.index())?
    | let i: I64 =>
      i
    end
