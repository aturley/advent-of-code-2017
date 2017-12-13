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

    let script = try
      env.args(2)?
    else
      _exit(env, "second argument must be the script", 1)
      return
    end

    match part
    | _Part1 =>
      let ht: HexTraveler ref = HexTraveler
      try
        RunTravelerScript(ht, script)?
        env.out.print(ht.distance_from_origin().string())
      else
        _exit(env, "error running script", 2)
      end
    | _Part2 =>
      let ht: HexTraveler ref = HexTraveler
      try
        RunTravelerScript(ht, script)?
        env.out.print(ht.furthest().string())
      else
        _exit(env, "error running script", 2)
      end
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
