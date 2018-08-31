use "collections"
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

    try
      let sm = StateMachineFromDescription(file_contents)?

      let tape = Tape

      sm.run(tape)?

      env.out.print(tape.sum().string())

    else
      _exit(env, "error processing tape", 1)
      return
    end
