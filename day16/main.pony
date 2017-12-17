use "collections"
use "debug"
use "logic"

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

    let commands: Array[String] val = try
      env.args(2)?.split(",")
    else
      _exit(env, "second argument must be the input", 1)
      return
    end

    match part
    | _Part1 =>
      let dl = DanceLine(16)
      try
        for c in commands.values() do
          ExecuteCommand(dl, c)?
        end
        env.out.print(String.from_array(dl.array()))
      else
        _exit(env, "error running commands", 2)
        return
      end
    | _Part2 =>
      try
        let compiled_commands = CompileCommands(commands)?
        let dla = DanceLineActor(16)
        dla.run_commands(compiled_commands, 1_000_000_000, env.out, true)
      else
        _exit(env, "error running commands", 2)
        return
      end
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
