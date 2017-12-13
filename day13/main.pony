use "collections"
use "debug"
use "files"
use "logic"

primitive _BuildScannersFromFile
  fun apply(env: Env, input_filename: String): Map[U64, U64] val ? =>
    let path = FilePath(env.root as AmbientAuth, input_filename)?

    let scanners = recover trn Map[U64, U64] end

    with file = OpenFile(path) as File do
      for l in file.lines() do
        let parts: Array[String] = l.split(" ")

        let depth': String ref = parts(0)?.clone()
        depth'.strip(":")
        let depth = depth'.u64()?

        let range = parts(1)?.u64()?

        scanners(depth) = range
      end
    end

    consume scanners

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

    let scanners = try
      _BuildScannersFromFile(env, input_filename)?
    else
      _exit(env, "error reading input file", 1)
      return
    end

    match part
    | _Part1 =>
      env.out.print(CalculateSeverity(scanners)._1.string())
    | _Part2 =>
      var delay: U64 = 0
      while true do
        (_, let caught) = CalculateSeverity(scanners, delay)
        if not caught then
          break
        end
        delay = delay + 1
      end
      env.out.print(delay.string())
    end

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
