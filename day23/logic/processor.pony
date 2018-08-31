class Processor
  let _instructions: Array[Instruction] box
  var _registers: Registers
  var _mul_count: USize

  new create(instructions: Array[Instruction] box, is_debugging: Bool,
    start_registers: (Array[I64] box | None) = None) =>
    _instructions = instructions
    _registers = match start_registers
    | let sr: Array[I64] box =>
      Registers.from_start(sr)
    else
      let r = Registers
      if not is_debugging then
        try r.set(Register('a'), 1)? end
      end
      r
    end

    _mul_count = 0

  fun ref next() ? =>
    let instruction = _instructions(_registers.get_pc())?
    match instruction
    | let _: Mul =>
      _mul_count = _mul_count + 1
    end

    instruction.exec(_registers)?
    _registers.inc_pc()

  fun mul_count(): USize =>
    _mul_count
