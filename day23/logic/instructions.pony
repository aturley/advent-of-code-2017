type Instruction is (Set | Sub | Mul | Jnz)

primitive _Value
  fun apply(arg: (Register | I64), registers: Registers): I64 ? =>
    match arg
    | let i64: I64 =>
      i64
    | let r: Register =>
      registers.get(r)?
    end

class val Set
  let _arg1: Register
  let _arg2: (Register | I64)

  new val create(arg1: Register, arg2: (Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun exec(registers: Registers) ? =>
    registers.set(_arg1, _Value(_arg2, registers)?)?

class val Sub
  let _arg1: Register
  let _arg2: (Register | I64)

  new val create(arg1: Register, arg2: (Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun exec(registers: Registers) ? =>
    registers.set(_arg1, _Value(_arg1, registers)? - _Value(_arg2, registers)?)?

class val Mul
  let _arg1: Register
  let _arg2: (Register | I64)

  new val create(arg1: Register, arg2: (Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun exec(registers: Registers) ? =>
    registers.set(_arg1, _Value(_arg1, registers)? * _Value(_arg2, registers)?)?

class val Jnz
  let _arg1: (Register | I64)
  let _arg2: (Register | I64)

  new val create(arg1: (Register | I64), arg2: (Register | I64)) =>
    _arg1 = arg1
    _arg2 = arg2

  fun exec(registers: Registers) ? =>
    let v = _Value(_arg1, registers)?
    if v != 0 then
      let offset = _Value(_arg2, registers)?.isize()
      let pc = registers.get_pc().isize()
      let new_pc = (pc + offset).usize() - 1
      registers.set_pc(new_pc)
    end
