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

    let input = try
      env.args(2)?
    else
      _exit(env, "second argument must be the input", 1)
      return
    end

    let hashes = try
      CalculateHashes(input)?
    else
      _exit(env, "error calculating hashes", 2)
      return
    end

    match part
    | _Part1 =>
      env.out.print(HashPopulations(hashes).string())
    | _Part2 =>
      env.out.print(CountRegions(hashes).string())
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
