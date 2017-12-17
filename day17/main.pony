use "collections"
use "debug"
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

    let input = try
      env.args(2)?.usize()?
    else
      _exit(env, "second argument must be the input", 1)
      return
    end

    match part
    | _Part1 =>
      let cb = CircularBuffer(input, 2017)
      env.out.print(cb.find_value_after(2017).string())
    | _Part2 =>
      let cb = CircularBuffer(input, 50_000_000)
      env.out.print(cb.find_value_after(0).string())
    end
