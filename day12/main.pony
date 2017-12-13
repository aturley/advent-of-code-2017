use "files"
use "logic"

primitive _BuildConnectionsFromFile
  fun apply(env: Env, input_filename: String): ProgramConnections ? =>
    let path = FilePath(env.root as AmbientAuth, input_filename)?

    let pc: ProgramConnections = ProgramConnections

    with file = OpenFile(path) as File do
      for l in file.lines() do
        let parts: Array[String] = l.split(" ")
        let start = parts(0)?
        for connection in parts.slice(2).values() do
          let c: String trn = connection.clone()
          c.strip(",")
          pc.add_connection(start, consume c)?
        end
      end
    end

    pc

primitive _Part1
primitive _Part2

actor Main
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

    let pc = try
      _BuildConnectionsFromFile(env, input_filename)?
    else
      _exit(env, "could not process connections", 1)
      return
    end

    match part
    | _Part1 =>
      env.out.print(FindGroup("0", pc).size().string())
    | _Part2 =>
      env.out.print(FindGroups(pc).size().string())
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
