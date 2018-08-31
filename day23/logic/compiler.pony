use "itertools"

primitive Error

primitive Compiler
  fun compile(code: String): (Array[Instruction] val | Error) =>
    recover val
      Iter[String](code.split("\n").values()).
        fold[(Array[Instruction] | Error)](Array[Instruction],
          {(a, s)(t = this): (Array[Instruction] | Error) =>
            match a
            | let ar: Array[Instruction] =>
              try
                ar.>push(t._compile_line(s)?)
              else
                Error
              end
            else
              Error
            end
            })
    end

  fun _compile_line(line: String): Instruction ? =>
    let part = line.split(" ")
    match part(0)?
    | "set" =>
      Set(_as_register(part(1)?)?, _as_register_or_i64(part(2)?)?)
    | "sub" =>
      Sub(_as_register(part(1)?)?, _as_register_or_i64(part(2)?)?)
    | "mul" =>
      Mul(_as_register(part(1)?)?, _as_register_or_i64(part(2)?)?)
    | "jnz" =>
      Jnz(_as_register_or_i64(part(1)?)?, _as_register_or_i64(part(2)?)?)
    else
      error
    end

  fun _as_register(reg_string: String): Register ? =>
    Register(reg_string.array()(0)?)

  fun _as_register_or_i64(arg: String): (Register | I64) ? =>
    try
      arg.i64()?
    else
      Register(arg.array()(0)?)
    end
