use "files"
use part1 = "part1"
use part2 = "part2"

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

    match part
    | _Part1 =>
      let instructions = try
        part1.Compiler.compile(file_contents.split("\n"))?
      else
        _exit(env, "error compiling input", 1)
        return
      end

      try
        let sc = part1.SoundComputer(instructions)

        while true do
          match sc.next()?
          | let f: I64 =>
            env.out.print(f.string())
            break
          end
        end
      else
        _exit(env, "error running the program", 2)
        return
      end

    | _Part2 =>
      let instructions = try
        part2.Compiler.compile(file_contents.split("\n"))?
      else
        _exit(env, "error compiling input", 1)
        return
      end

      try
        let sc0 = part2.SoundComputer(0, instructions)
        let sc1 = part2.SoundComputer(1, instructions)
        sc0.partner(sc1)
        sc1.partner(sc0)

        let res = part2.Runner(sc0, sc1)?

        env.out.print(res._2.string())
      else
        _exit(env, "error running the program", 2)
        return
      end
    end
