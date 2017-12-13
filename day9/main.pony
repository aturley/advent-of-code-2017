use "files"
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

    let stream_filename = try
      env.args(2)?
    else
      _exit(env, "second argument must be input file name", 1)
      return
    end

    let stream = try
      _read_stream_from_filename(env.root as AmbientAuth, stream_filename)?
    else
      _exit(env, "could not read the input file", 1)
      return
    end

    match part
    | _Part1 =>
      env.out.print(GetGroupScoreAndRemovedCount(stream)._1.string())
    | _Part2 =>
      env.out.print(GetGroupScoreAndRemovedCount(stream)._2.string())
    end

  fun _read_stream_from_filename(auth: AmbientAuth, filename: String):
    String
  ? =>
    let stream = recover trn String end

    let path = FilePath(auth, filename)?

    with file = OpenFile(path) as File do
      for l in file.lines() do
        stream.append(l)
      end
    end

    consume stream

  fun _exit(env: Env, message: String, exitcode: I32 = 0) =>
    env.err.print(message)
    env.exitcode(exitcode)
