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

    (let seed_a, let seed_b) = try
      (env.args(2)?.u64()?, env.args(3)?.u64()?)
    else
      _exit(env, "second and third arguments must be the seeds", 1)
      return
    end

    let gen_a = GeneratorFromFactorAndSeed(16807, seed_a)
    let gen_b = GeneratorFromFactorAndSeed(48271, seed_b)

    match part
    | _Part1 =>
      env.out.print(ScoreSequences(gen_a, gen_b, 40_000_000).string())
    | _Part2 =>
      let crit_a = recover val {(x: U64): Bool => (x % 4) == 0} end
      let crit_b = recover val {(x: U64): Bool => (x % 8) == 0} end

      env.out.print(ScoreSequencesWithCriteria(gen_a, gen_b, crit_a, crit_b,
        5_000_000).string())
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
