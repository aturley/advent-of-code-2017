primitive _Part1
primitive _Part2

actor Main
  new create(env: Env) =>
    let part = try
      match env.args(1)?
      | "part1" =>
        _Part1
      | "part2" =>
        _Part2
      else
        error
      end
    else
      env.err.print("please supply 'part1' or 'part2' as the first argument")
      env.exitcode(1)
      return
    end

    let target = try
      env.args(2)?.u64()?
    else
      env.err.print("the target must be the second argument")
      env.exitcode(1)
      return
    end

    match part
    | _Part1 =>
      Part1(env, target)
    | _Part2 =>
      Part2(env, target)
    end
