primitive Compiler
  fun compile(input: Array[String] box): Array[Instruction] val ? =>
    let instructions = recover trn Array[Instruction] end

    for i in input.values() do
      let parts = i.split(" ")
      match parts(0)?
      | "snd" =>
        instructions.push(_Snd(_reg_or_i64(parts(1)?)?))
      | "set" =>
        instructions.push(_Set(_Register(parts(1)?)?, _reg_or_i64(parts(2)?)?))
      | "add" =>
        instructions.push(_Add(_Register(parts(1)?)?, _reg_or_i64(parts(2)?)?))
      | "mul" =>
        instructions.push(_Mul(_Register(parts(1)?)?, _reg_or_i64(parts(2)?)?))
      | "mod" =>
        instructions.push(_Mod(_Register(parts(1)?)?, _reg_or_i64(parts(2)?)?))
      | "rcv" =>
        instructions.push(_Rcv(_Register(parts(1)?)?))
      | "jgz" =>
        instructions.push(_Jgz(_reg_or_i64(parts(1)?)?, _reg_or_i64(parts(2)?)?))
      end
    end

    consume instructions

  fun _reg_or_i64(s: String): (_Register | I64) ? =>
    if (s.size() == 1) and ((s(0)? >= 'a') and (s(0)? <= 'z')) then
      _Register(s)?
    else
      s.i64()?
    end
