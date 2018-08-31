use "files"
use "logic"

primitive _Part1
primitive _Part2

actor Main
  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)

  new create(env: Env) =>
    let part = try
      match env.args(1)?
      | "part1" => _Part1
      | "part2" => _Part2
      else
        error
      end
    else
      _exit(env, "first argument must be 'part1' or 'part2'", 1)
      return
    end

    let input_filename = try
      env.args(2)?
    else
      _exit(env, "second argument must be the input filename", 1)
      return
    end

    let file_contents: String = try
      var s: String = ""
      let path = FilePath(env.root as AmbientAuth, input_filename)?
      with file = OpenFile(path) as File do
        s = String.from_array(file.read(file.size()))
      end
      s
    else
      _exit(env, "error reading " + input_filename, 1)
      return
    end

    let start_registers = try
      let start_register_args = env.args.slice(3)
      match start_register_args.size()
      | 0 =>
        None
      | 9 =>
        let srs = Array[I64]
        for sr in start_register_args.values() do
          srs.push(sr.split("=")(1)?.i64()?)
        end
        srs
      else
        error
      end
    else
      _exit(env, "not enough start registers specified", 1)
      return
    end

    let is_debugging = part is _Part1
    try
      let instructions = Compiler.compile(file_contents)
        as Array[Instruction] val
      let proc = Processor(instructions, is_debugging, start_registers)
      try
        while true do
          proc.next()?
        end
      end
      env.out.print(proc.mul_count().string())
    else
      _exit(env, "error running program", 1)
      return
    end
