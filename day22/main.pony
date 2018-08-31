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

    (let iterations: USize, let evolved: Bool) = match part
    | _Part1 =>
      (10_000, false)
    | _Part2 =>
      (10_000_000, true)
    end

    try
      let grid = GridFromStrings(file_contents.split("\n"))?
      var carrier = Carrier(((grid.size() / 2).isize(), (grid.size() / 2).isize()))
      for _ in Range(0, iterations) do
        carrier.burst(grid, evolved)?
      end
      env.out.print(carrier.infections().string())
    else
      _exit(env, "error doing transforms", 2)
      return
    end
